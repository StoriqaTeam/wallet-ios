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
    private let resendConfirmEmailNetworkProvider: ResendConfirmEmailNetworkProviderProtocol
    private let ratesUpdater: RatesUpdaterProtocol
    
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
         signHeaderFactory: SignHeaderFactoryProtocol,
         resendConfirmEmailNetworkProvider: ResendConfirmEmailNetworkProviderProtocol,
         ratesUpdater: RatesUpdaterProtocol) {
        
        self.socialViewVM = socialViewVM
        self.defaultProvider = defaultProvider
        self.biometricAuthProvider = biometricAuthProvider
        self.userDataStore = userDataStore
        self.keychain = keychain
        self.loginService = loginService
        self.userKeyManager = userKeyManager
        self.addDeviceNetworkProvider = addDeviceNetworkProvider
        self.signHeaderFactory = signHeaderFactory
        self.resendConfirmEmailNetworkProvider = resendConfirmEmailNetworkProvider
        self.ratesUpdater = ratesUpdater
    }
}


// MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {
    
    func viewIsReady() {
        userDataStore.resetAllDatabase()
        keychain.deleteAll()
        defaultProvider.clear()
        ratesUpdater.update()
    }
    
    func getSocialVM() -> SocialNetworkAuthViewModel {
        return socialViewVM
    }
    
    func signIn(email: String, password: String) {
        authData = AuthData.email(email: email, password: password)
        
        guard let _ = userKeyManager.addPrivateKeyIfNeeded(email: email) else {
            log.error("Fail to add pair email and private key")
            return
        }
        
        loginService.signIn(email: email, password: password) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success:
                strongSelf.loginSucceed()
            case .failure(let error):
                if let error = error as? AuthNetworkError {
                    strongSelf.output.formValidationFailed(email: error.email, password: error.password)
                    return
                }
                
                if let error = error as? DeviceNetworkError,
                    case .deviceNotRegistered(let userId) = error {
                    strongSelf.deviceRegisterUserId = userId
                    strongSelf.output.deviceNotRegistered()
                    return
                }
                
                if let error = error as? EmailNetworkError,
                    case .emailNotVerified = error {
                    strongSelf.output.emailNotVerified()
                    return
                }
                
                strongSelf.output.loginFailed(message: error.localizedDescription)
            }
        }
    }
    
    func signIn(tokenProvider: SocialNetworkTokenProvider, oauthToken: String, email: String) {
        authData = AuthData.social(provider: tokenProvider, token: oauthToken, email: email)
        
        guard let _ = userKeyManager.addPrivateKeyIfNeeded(email: email) else {
            log.error("Fail to add pair email and private key")
            return
        }
        
        loginService.signIn(tokenProvider: tokenProvider, oauthToken: oauthToken, email: email) { [weak self] (result) in
            switch result {
            case .success:
                self?.loginSucceed()
            case .failure(let error):
                if let error = error as? DeviceNetworkError,
                    case .deviceNotRegistered(let userId) = error {
                    self?.deviceRegisterUserId = userId
                    self?.output.deviceNotRegistered()
                    return
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
            guard let _ = userKeyManager.addPrivateKeyIfNeeded(email: email) else {
                log.error("Fail to add pair email and private key")
                return
            }
            
            signIn(email: email, password: password)
        case .social(let provider, let token, let email):
            signIn(tokenProvider: provider, oauthToken: token, email: email)
        }
    }
    
    func registerDevice() {
        guard let userId = deviceRegisterUserId,
            let authData = authData else {
            fatalError("Registring device with no user id")
        }
        
        let currentEmail: String
        
        switch authData {
        case .email(let email, _):
            currentEmail = email
        case .social(_, _, let email):
            currentEmail = email
        }
        
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: currentEmail)
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
    
    func resendConfirmationEmail() {
        guard let authData = authData else {
            fatalError("Trying to resend confirmation email without previous auth data")
        }
        
        let currentEmail: String
        
        switch authData {
        case .email(let email, _):
            currentEmail = email
        case .social:
            fatalError("Trying to resend confirmation email after social network auth")
        }
        
        resendConfirmEmailNetworkProvider.confirmAddDevice(
            email: currentEmail,
            queue: .main) { [weak self] (result) in
                switch result {
                case .success:
                    self?.output.confirmEmailSentSuccessfully(email: currentEmail)
                case .failure(let error):
                    self?.output.confirmEmailSendingFailed(message: error.localizedDescription)
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
}
