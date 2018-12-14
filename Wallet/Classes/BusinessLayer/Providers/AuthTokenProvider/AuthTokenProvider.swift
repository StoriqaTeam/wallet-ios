//
//  AuthTokenProvider.swift
//  Wallet
//
//  Created by Storiqa on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable function_body_length

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
    private let socialAuthNetworkProvider: SocialAuthNetworkProviderProtocol
    private let authDataResolver: AuthDataResolverProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private let refreshTokenNetworkProvider: RefreshTokenNetworkProviderProtocol
    
    private var now: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    init(defaults: AuthTokenDefaultsProviderProtocol,
         socialAuthNetworkProvider: SocialAuthNetworkProviderProtocol,
         authDataResolver: AuthDataResolverProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol,
         refreshTokenNetworkProvider: RefreshTokenNetworkProviderProtocol) {
        
        self.defaults = defaults
        self.jwtParser = JwtTokenParser()
        self.socialAuthNetworkProvider = socialAuthNetworkProvider
        self.authDataResolver = authDataResolver
        self.signHeaderFactory = signHeaderFactory
        self.refreshTokenNetworkProvider = refreshTokenNetworkProvider
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
        
        guard let email = authDataResolver.getAuthData() else {
            let error = AuthTokenProviderError.invalidLoginData
            log.warn(error.localizedDescription)
            completion(.failure(error))
            return
        }
        
        refreshToken(aToken, email: email, completion: completion)
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
    
    private func refreshToken(_ authToken: AuthToken, email: String, completion: @escaping (Result<String>) -> Void) {
        
        let signHeader: SignHeader
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: email)
        } catch {
            completion(.failure(error))
            return
        }
        
        
        refreshTokenNetworkProvider.refreshAuthToken(authToken: authToken.token,
                                                     signHeader: signHeader,
                                                     queue: .main) { [weak self] (result) in
                                                        guard let strongSelf = self else {
                                                            let error = AuthTokenProviderError.failToGetTokenFromDefaults
                                                            log.error("Auth Token provider release")
                                                            completion(.failure(error))
                                                            return
                                                        }
                                                        
                                                        switch result {
                                                        case .success(let token):
                                                            log.info("Success update auth token")
                                                            strongSelf.defaults.authToken = token
                                                            completion(.success(token))
                                                        case .failure(let error):
                                                            completion(.failure(error))
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
