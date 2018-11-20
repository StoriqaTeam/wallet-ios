//
//  AuthDataResolver.swift
//  Wallet
//
//  Created by Storiqa on 06/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


enum AuthData {
    case email(email: String, password: String)
    case social(provider: SocialNetworkTokenProvider, token: String, email: String)
}


protocol AuthDataResolverProtocol {
    func getAuthData() -> AuthData?
}

class AuthDataResolver: AuthDataResolverProtocol {
    
    private let keychain: KeychainProviderProtocol
    private let defaults: DefaultsProviderProtocol
    private let userDataStore: UserDataStoreServiceProtocol
    
    init(defaults: DefaultsProviderProtocol,
         keychain: KeychainProviderProtocol,
         userDataStoreService: UserDataStoreServiceProtocol) {
        self.keychain = keychain
        self.defaults = defaults
        self.userDataStore = userDataStoreService
    }
    
    func getAuthData() -> AuthData? {
        let user = userDataStore.getCurrentUser()
        let email = user.email

        if let socialProvider = defaults.socialAuthProvider,
            let socialToken = keychain.socialAuthToken {
            let authData = AuthData.social(provider: socialProvider, token: socialToken, email: email)
            return authData
        } else if let password = keychain.password {
            let authData = AuthData.email(email: email, password: password)
            return authData
        } else {
            return nil
        }
    }
    
}
