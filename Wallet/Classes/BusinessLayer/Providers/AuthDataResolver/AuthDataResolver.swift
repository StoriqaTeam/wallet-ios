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
    func getAuthData() -> String?
}

class AuthDataResolver: AuthDataResolverProtocol {
    
    private let userDataStore: UserDataStoreServiceProtocol
    
    init(userDataStoreService: UserDataStoreServiceProtocol) {
        
        self.userDataStore = userDataStoreService
    }
    
    func getAuthData() -> String? {
        let user = userDataStore.getCurrentUser()
        let email = user.email
        return email
    }
    
}
