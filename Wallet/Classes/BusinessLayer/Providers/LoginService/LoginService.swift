//
//  LoginService.swift
//  Wallet
//
//  Created by Storiqa on 06/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol LoginServiceProtocol {
    func signIn(email: String, password: String, completion: @escaping (Result<String?>) -> Void)
    func signIn(tokenProvider: SocialNetworkTokenProvider,
                oauthToken: String,
                email: String,
                completion: @escaping (Result<String?>) -> Void)
}


class LoginService: LoginServiceProtocol {
    
    private let authTokenDefaultsProvider: AuthTokenDefaultsProviderProtocol
    private let loginNetworkProvider: LoginNetworkProviderProtocol
    private let socialAuthNetworkProvider: SocialAuthNetworkProviderProtocol
    private let userNetworkProvider: CurrentUserNetworkProviderProtocol
    private let userDataStore: UserDataStoreServiceProtocol
    private let keychain: KeychainProviderProtocol
    private let defaults: DefaultsProviderProtocol
    private let accountsNetworkProvider: AccountsNetworkProviderProtocol
    private let accountsDataStore: AccountsDataStoreServiceProtocol
    private let defaultAccountsProvider: DefaultAccountsProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    
    init(authTokenDefaultsProvider: AuthTokenDefaultsProviderProtocol,
         loginNetworkProvider: LoginNetworkProviderProtocol,
         socialAuthNetworkProvider: SocialAuthNetworkProviderProtocol,
         userNetworkProvider: CurrentUserNetworkProviderProtocol,
         userDataStore: UserDataStoreServiceProtocol,
         keychain: KeychainProviderProtocol,
         defaults: DefaultsProviderProtocol,
         accountsNetworkProvider: AccountsNetworkProviderProtocol,
         accountsDataStore: AccountsDataStoreServiceProtocol,
         defaultAccountsProvider: DefaultAccountsProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol) {
        
        self.authTokenDefaultsProvider = authTokenDefaultsProvider
        self.loginNetworkProvider = loginNetworkProvider
        self.socialAuthNetworkProvider = socialAuthNetworkProvider
        self.userNetworkProvider = userNetworkProvider
        self.userDataStore = userDataStore
        self.accountsNetworkProvider = accountsNetworkProvider
        self.accountsDataStore = accountsDataStore
        self.keychain = keychain
        self.defaults = defaults
        self.defaultAccountsProvider = defaultAccountsProvider
        self.signHeaderFactory = signHeaderFactory
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<String?>) -> Void) {
        
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: email)
        } catch {
            completion(.failure(error))
            return
        }
        
        loginNetworkProvider.loginUser(
            email: email,
            password: password,
            queue: .main,
            signHeader: signHeader) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let authToken):
                    strongSelf.authTokenDefaultsProvider.authToken = authToken
                    strongSelf.keychain.password = password
                    strongSelf.defaults.socialAuthProvider = nil
                    strongSelf.keychain.socialAuthToken = nil
                    strongSelf.getUser(authToken: authToken,
                                       authData: .email(email: email, password: password),
                                       completion: completion)
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
    
    func signIn(tokenProvider: SocialNetworkTokenProvider,
                oauthToken: String,
                email: String,
                completion: @escaping (Result<String?>) -> Void) {
        
        let signHeader: SignHeader
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: email)
        } catch {
            completion(.failure(error))
            return
        }
        
        socialAuthNetworkProvider.socialAuth(
            oauthToken: oauthToken,
            oauthProvider: tokenProvider,
            queue: .main,
            signHeader: signHeader) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let authToken):
                    strongSelf.authTokenDefaultsProvider.authToken = authToken
                    strongSelf.defaults.socialAuthProvider = tokenProvider
                    strongSelf.keychain.socialAuthToken = oauthToken
                    strongSelf.keychain.password = nil
                    strongSelf.getUser(authToken: authToken,
                                       authData: AuthData.social(provider: tokenProvider, token: oauthToken, email: email),
                                       completion: completion)
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
}


// MARK: - Private methods

extension LoginService {
    private func getUser(authToken: String, authData: AuthData, completion: @escaping (Result<String?>) -> Void) {
        
        let currentEmail: String
        
        switch authData {
        case .email(let email, _): currentEmail = email
        case .social: fatalError("Needs email")
        }
        
        let signHeader: SignHeader 
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: currentEmail)
        } catch {
            completion(.failure(error))
            return
        }
        
        userNetworkProvider.getCurrentUser(
            authToken: authToken,
            queue: .main,
            signHeader: signHeader) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let user):
                    strongSelf.userDataStore.update(user)
                    strongSelf.getAccounts(authToken: authToken, authData: authData, userId: user.id, completion: completion)
                    
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    private func getAccounts(authToken: String, authData: AuthData, userId: Int, completion: @escaping (Result<String?>) -> Void) {
        
        let currentEmail = userDataStore.getCurrentUser().email
        
        let signHeader: SignHeader
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: currentEmail)
        } catch {
            completion(.failure(error))
            return
        }
        
        accountsNetworkProvider.getAccounts(
            authToken: authToken,
            userId: userId,
            queue: .main,
            signHeader: signHeader) { [weak self] (result) in
                switch result {
                case .success(let accounts):
                    guard !accounts.isEmpty else {
                        log.error("User has no accounts. Trying to create default")
                        self?.createDefaultAccounts(authData: authData, completion: completion)
                        return
                    }
                    
                    log.debug(accounts.map { $0.id })
                    self?.accountsDataStore.update(accounts)
                    completion(.success(nil))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    private func createDefaultAccounts(authData: AuthData, completion: @escaping (Result<String?>) -> Void) {
        defaultAccountsProvider.create { (result) in
            switch result {
            case .success:
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
