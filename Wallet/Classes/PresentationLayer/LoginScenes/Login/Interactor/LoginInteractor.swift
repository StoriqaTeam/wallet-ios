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
    private let addDeviceNetworkProvider: AddDeviceNetworkProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    
    // for Retry
    private var authData: AuthData?
    private var deviceRegisterUserId: Int?
    
    init(socialViewVM: SocialNetworkAuthViewModel,
         defaultProvider: DefaultsProviderProtocol,
         biometricAuthProvider: BiometricAuthProviderProtocol,
         userDataStore: UserDataStoreServiceProtocol,
         keychain: KeychainProviderProtocol,
         loginService: LoginServiceProtocol,
         keyGenerator: KeyGeneratorProtocol,
         userKeyManager: UserKeyManagerProtocol,
         addDeviceNetworkProvider: AddDeviceNetworkProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol) {
        
        self.socialViewVM = socialViewVM
        self.defaultProvider = defaultProvider
        self.biometricAuthProvider = biometricAuthProvider
        self.userDataStore = userDataStore
        self.keychain = keychain
        self.loginService = loginService
        self.userKeyManager = userKeyManager
        self.addDeviceNetworkProvider = addDeviceNetworkProvider
        self.signHeaderFactory = signHeaderFactory
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
            switch result {
            case .success:
                self?.loginSucceed()
            case .failure(let error):
                if let error = error as? LoginProviderError {
                    switch error {
                    case .validationError(let email, let password):
                        self?.output.formValidationFailed(email: email, password: password)
                        return
                    case .deviceNotRegistered(let userId):
                        self?.deviceRegisterUserId = userId
                        self?.output.deviceNotRegistered()
                        return
                    default: break
                    }
                }
                
                self?.output.loginFailed(message: error.localizedDescription)
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
                if let error = error as? SocialAuthNetworkProviderError {
                    switch error {
                    case .deviceNotRegistered(let userId):
                        self?.deviceRegisterUserId = userId
                        self?.output.deviceNotRegistered()
                        return
                    default: break
                    }
                }
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
            signIn(tokenProvider: provider, oauthToken: token)
        }
    }
    
    func registerDevice() {
        guard let userId = deviceRegisterUserId else {
            fatalError("Registring device with no user id")
        }
        
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader()
        } catch {
            log.error(error.localizedDescription)
            output.loginFailed(message: error.localizedDescription)
            return
        }
        
        addDeviceNetworkProvider.addDevice(
            userId: userId,
            signHeader: signHeader,
            queue: .main) { [weak self] (result) in
                switch result {
                case .success:
                    self?.output.deviceRegisterEmailSent()
                case .failure(let error):
                    self?.output.failedSendDeviceRegisterEmail(message: error.localizedDescription)
                }
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
