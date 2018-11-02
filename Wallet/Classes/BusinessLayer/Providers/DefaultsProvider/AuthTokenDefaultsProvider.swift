//
//  AuthTokenDefaultsProvider.swift
//  Wallet
//
//  Created by Storiqa on 24/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

/** Get token ONLY from AuthTokenProvider */

protocol AuthTokenDefaultsProviderProtocol: class {
    var authToken: String? { get set }
}


class AuthTokenDefaultsProvider: AuthTokenDefaultsProviderProtocol {
    private let kAuthToken = "authToken"
    
    var authToken: String? {
        get {
            return getAuthToken()
        }
        set {
            setAuthToken(newValue)
        }
    }
}


// MARK: - Private methods

extension AuthTokenDefaultsProvider {
    private func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: kAuthToken)
    }
    
    private func setAuthToken(_ value: String?) {
        UserDefaults.standard.set(value, forKey: kAuthToken)
        UserDefaults.standard.synchronize()
    }
}
