//
//  AuthTokenProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 23/10/2018.
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
    private let keychain: KeychainProviderProtocol
    private let userDataStore: UserDataStoreServiceProtocol
    private let loginNetworkProvider: LoginNetworkProviderProtocol
    
    private var now: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    init(defaults: AuthTokenDefaultsProviderProtocol,
         keychain: KeychainProviderProtocol,
         loginNetworkProvider: LoginNetworkProviderProtocol,
         userDataStoreService: UserDataStoreServiceProtocol) {
        
        self.keychain = keychain
        self.defaults = defaults
        self.jwtParser = JwtTokenParser()
        self.userDataStore = userDataStoreService
        self.loginNetworkProvider = loginNetworkProvider
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
        
        guard let loginData = compareUserMetadata(authToken: aToken) else {
            let error = AuthTokenProviderError.invalidLoginData
            log.warn(error.localizedDescription)
            completion(.failure(error))
            return
        }
        
        let password = loginData.password
        let email = loginData.email
        
        loginNetworkProvider.loginUser(email: email, password: password, queue: .main) {[weak self] (result) in
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
    
    private func compareUserMetadata(authToken: AuthToken) -> (email: String, password: String)? {
        let user = userDataStore.getCurrentUser()
        let email = user.email
        guard let password = keychain.password else { return nil }
        
        // TODO: - Compare user id and authToken id
        return (email: email, password: password)
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
