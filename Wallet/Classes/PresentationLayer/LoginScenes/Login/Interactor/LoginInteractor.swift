//
//  LoginLoginInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class LoginInteractor {
    weak var output: LoginInteractorOutput!
    
    private let socialViewVM: SocialNetworkAuthViewModel
    private let defaultProvider: DefaultsProviderProtocol
    private let biometricAuthProvider: BiometricAuthProviderProtocol
    private let loginNetworkProvider: LoginNetworkProviderProtocol
    private let userNetworkProvider: CurrentUserNetworkProviderProtocol
    private let userDataStore: UserDataStoreServiceProtocol
    private let keychain: KeychainProviderProtocol
    private let accountsNetworkProvider: AccountsNetworkProviderProtocol
    private let accountsDataStore: AccountsDataStoreProtocol
    
    init(socialViewVM: SocialNetworkAuthViewModel,
         defaultProvider: DefaultsProviderProtocol,
         biometricAuthProvider: BiometricAuthProviderProtocol,
         loginNetworkProvider: LoginNetworkProvider,
         userNetworkProvider: CurrentUserNetworkProviderProtocol,
         userDataStore: UserDataStoreServiceProtocol,
         keychain: KeychainProviderProtocol,
         accountsNetworkProvider: AccountsNetworkProviderProtocol,
         accountsDataStore: AccountsDataStoreProtocol) {
        
        self.socialViewVM = socialViewVM
        self.defaultProvider = defaultProvider
        self.biometricAuthProvider = biometricAuthProvider
        self.loginNetworkProvider = loginNetworkProvider
        self.userNetworkProvider = userNetworkProvider
        self.userDataStore = userDataStore
        self.accountsNetworkProvider = accountsNetworkProvider
        self.accountsDataStore = accountsDataStore
        self.keychain = keychain
    }
}


// MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {
    
    func getSocialVM() -> SocialNetworkAuthViewModel {
        return socialViewVM
    }
    
    func signIn(email: String, password: String) {
        loginNetworkProvider.loginUser(
            email: email,
            password: password,
            queue: .main) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let authToken):
                    strongSelf.defaultProvider.authToken = authToken
                    strongSelf.keychain.password = password
                    strongSelf.getUser(authToken: authToken, authData: .email(email: email, password: password))
                case .failure(let error):
                    strongSelf.output.failToLogin(reason: error.localizedDescription)
                }
        }
    }
    
    func signIn(tokenProvider: SocialNetworkTokenProvider, socialNetworkToken: String) {
        //TODO: implement in new provider
        log.warn("implement login provider")
        
        // FIXME: - stub
        loginSucceed(authData: .socialProvider(provider: tokenProvider, token: socialNetworkToken))
        // ------------------------------
    }
}


// MARK: - Private methods

extension LoginInteractor {
    private func getUser(authToken: String, authData: AuthData) {
        userNetworkProvider.getCurrentUser(
            authToken: authToken,
            queue: .main) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let user):
                    strongSelf.userDataStore.update(user)
                    strongSelf.getAccounts(authToken: authToken, authData: authData, userId: user.id)
                    
                case .failure(let error):
                    strongSelf.output.failToLogin(reason: error.localizedDescription)
                }
        }
    }
    
    private func getAccounts(authToken: String, authData: AuthData, userId: Int) {
        accountsNetworkProvider.getAccounts(
            authToken: authToken,
            userId: userId,
            queue: .main) { [weak self] (result) in
                switch result {
                case .success(let accounts):
                    log.debug(accounts.map { $0.id })
                    self?.accountsDataStore.update(accounts)
                    self?.loginSucceed(authData: authData)
                    
                case .failure(let error):
                    self?.output.failToLogin(reason: error.localizedDescription)
                    log.warn(error.localizedDescription)
                }
        }
    }
    
    private func loginSucceed(authData: AuthData) {
        if !defaultProvider.isQuickLaunchShown {
            if biometricAuthProvider.canAuthWithBiometry {
                output.showQuickLaunch(authData: authData, token: "")
            } else {
                output.showPinQuickLaunch(authData: authData, token: "")
            }
            
            defaultProvider.isQuickLaunchShown = true
        } else {
            output.loginSucceed()
        }
    }
}
