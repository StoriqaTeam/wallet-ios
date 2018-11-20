//
//  AuthTokenProvider.swift
//  Wallet
//
//  Created by Storiqa on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


struct AuthToken {
    let token: String
    let userId: UInt
    var expiredTimeStamp: UInt
}


protocol AuthTokenProviderProtocol {
    func currentAuthToken(completion: @escaping (Result<String>) -> Void)
} 


class AuthTokenProvider: AuthTokenProviderProtocol {
    
    private var authToken: AuthToken?
    private let jwtParser: JwtTokenParserProtocol
    private let defaults: AuthTokenDefaultsProviderProtocol
    private let loginNetworkProvider: LoginNetworkProviderProtocol
    private let socialAuthNetworkProvider: SocialAuthNetworkProviderProtocol
    private let authDataResolver: AuthDataResolverProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    
    private var now: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    init(defaults: AuthTokenDefaultsProviderProtocol,
         loginNetworkProvider: LoginNetworkProviderProtocol,
         socialAuthNetworkProvider: SocialAuthNetworkProviderProtocol,
         authDataResolver: AuthDataResolverProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol) {
        
        self.defaults = defaults
        self.jwtParser = JwtTokenParser()
        self.loginNetworkProvider = loginNetworkProvider
        self.socialAuthNetworkProvider = socialAuthNetworkProvider
        self.authDataResolver = authDataResolver
        self.signHeaderFactory = signHeaderFactory
    }
    
    func currentAuthToken(completion: @escaping (Result<String>) -> Void) {
        setTokenFromDefaults()
        
        guard let aToken = authToken else {
            let error = AuthTokenProviderError.failToGetTokenFromDefaults
            log.warn(error.localizedDescription)
            completion(.failure(error))
            return
        }
        
        if !isExpiredToken() {
            completion(.success(aToken.token))
            return
        }
        
        guard let loginData = authDataResolver.getAuthData() else {
            let error = AuthTokenProviderError.invalidLoginData
            log.warn(error.localizedDescription)
            completion(.failure(error))
            return
        }
        
        login(authData: loginData, completion: completion)
    }
}


// MARK: - Private methods

extension AuthTokenProvider {
    private func setTokenFromDefaults() {
        guard let jwtTokenString = defaults.authToken else {
            authToken = nil
            return
        }
        
        authToken = jwtParser.parse(jwtToken: jwtTokenString)
    }
    
    private func isExpiredToken() -> Bool {
        guard let expiredTime = authToken?.expiredTimeStamp else { return false }
        return now >= expiredTime
    }
    
    private func login(authData: AuthData, completion: @escaping (Result<String>) -> Void) {
        
        switch authData {
        case .email(let email, let password):
            let signHeader: SignHeader
            
            do {
                signHeader = try signHeaderFactory.createSignHeader(email: email)
            } catch {
                completion(.failure(error))
                return
            }
            
            loginNetworkProvider.loginUser(email: email,
                                           password: password,
                                           queue: .main,
                                           signHeader: signHeader) {[weak self] (result) in
                guard let strongSelf = self else {
                    let error = AuthTokenProviderError.failToGetTokenFromDefaults
                    log.error("Auth Token provider release")
                    completion(.failure(error))
                    return
                }
                
                switch result {
                case .success(let token):
                    log.info("Success update auth token")
                    completion(.success(token))
                    strongSelf.defaults.authToken = token
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .social(let provider, let token):
            
            fatalError("Needs email")
            let stubSignHeader = SignHeader(deviceId: "stub", timestamp: "stub", signature: "stub", pubKeyHex: "stub")
            socialAuthNetworkProvider.socialAuth(oauthToken: token,
                                                 oauthProvider: provider,
                                                 queue: .main,
                                                 signHeader: stubSignHeader) { [weak self] (result) in
                guard let strongSelf = self else {
                    let error = AuthTokenProviderError.failToGetTokenFromDefaults
                    log.error("Auth Token provider release")
                    completion(.failure(error))
                    return
                }
                
                switch result {
                case .success(let token):
                    log.info("Success update auth token")
                    completion(.success(token))
                    strongSelf.defaults.authToken = token
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}


enum AuthTokenProviderError: LocalizedError, Error {
    case failToGetTokenFromDefaults
    case invalidLoginData
    
    var errorDescription: String? {
        switch self {
        case .failToGetTokenFromDefaults:
            return "Failed to get token from user defaults"
        case .invalidLoginData:
            return "Invalid login data"
        }
    }
}
