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
    private let userDataStore: UserDataStoreServiceProtocol
    private let keychain: KeychainProviderProtocol
    private let loginService: LoginServiceProtocol
    private let userKeyManager: UserKeyManagerProtocol
    
    // for Retry
    private var authData: AuthData?
    
    init(socialViewVM: SocialNetworkAuthViewModel,
         defaultProvider: DefaultsProviderProtocol,
         biometricAuthProvider: BiometricAuthProviderProtocol,
         userDataStore: UserDataStoreServiceProtocol,
         keychain: KeychainProviderProtocol,
         loginService: LoginServiceProtocol,
         keyGenerator: KeyGeneratorProtocol,
         userKeyManager: UserKeyManagerProtocol) {
        
        self.socialViewVM = socialViewVM
        self.defaultProvider = defaultProvider
        self.biometricAuthProvider = biometricAuthProvider
        self.userDataStore = userDataStore
        self.keychain = keychain
        self.loginService = loginService
        self.userKeyManager = userKeyManager
    }
}


// MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {
    
    func viewIsReady() {
        userDataStore.resetAllDatabase()
        keychain.deleteAll()
        defaultProvider.clear()
    }
    
    func getSocialVM() -> SocialNetworkAuthViewModel {
        return socialViewVM
    }
    
    func signIn(email: String, password: String) {
        authData = AuthData.email(email: email, password: password)
        setNewPrivateKeyIfNeeded(with: email)
        
        loginService.signIn(email: email, password: password) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success:
                strongSelf.loginSucceed()
            case .failure(let error):
                if let error = error as? LoginProviderError {
                    switch error {
                    case .validationError(let email, let password):
                        strongSelf.output.formValidationFailed(email: email, password: password)
                        return
                    default: break
                    }
                }
                
                strongSelf.output.loginFailed(message: error.localizedDescription)
            }
        }
    }
    
    func signIn(tokenProvider: SocialNetworkTokenProvider, oauthToken: String) {
        authData = AuthData.social(provider: tokenProvider, token: oauthToken)
        fatalError("Implement with userKeyManager. Need pass email")
        
        loginService.signIn(tokenProvider: tokenProvider, oauthToken: oauthToken) { [weak self] (result) in
            switch result {
            case .success:
                self?.loginSucceed()
            case .failure(let error):
                self?.output.loginFailed(message: error.localizedDescription)
            }
        }
    }
    
    func retry() {
        guard let authData = authData else {
            fatalError("Retrying to login without previous auth data")
        }
        
        switch authData {
        case .email(let email, let password):
            setNewPrivateKeyIfNeeded(with: email)
            signIn(email: email, password: password)
        case .social(let provider, let token):
            fatalError("Implement with userKeyManager. Need pass email")
            signIn(tokenProvider: provider, oauthToken: token)
        }
    }
    
}


// MARK: - Private methods

extension LoginInteractor {
    private func loginSucceed() {
        if biometricAuthProvider.canAuthWithBiometry {
            output.showQuickLaunch()
        } else {
            output.showPinQuickLaunch()
        }
    }
    
    private func setNewPrivateKeyIfNeeded(with email: String) {
        guard userKeyManager.getPrivateKeyFor(email: email) == nil else { return }
        let _ = userKeyManager.setNewPrivateKey(email: email)
    }
}
