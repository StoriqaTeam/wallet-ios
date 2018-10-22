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
    
    init(socialViewVM: SocialNetworkAuthViewModel,
         defaultProvider: DefaultsProviderProtocol,
         biometricAuthProvider: BiometricAuthProviderProtocol,
         loginNetworkProvider: LoginNetworkProvider) {
        
        self.socialViewVM = socialViewVM
        self.defaultProvider = defaultProvider
        self.biometricAuthProvider = biometricAuthProvider
        self.loginNetworkProvider = loginNetworkProvider
    }
}


// MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {
    
    func getSocialVM() -> SocialNetworkAuthViewModel {
        return socialViewVM
    }
    
    func signIn(email: String, password: String) {
        output.loader(isShown: true)
        loginNetworkProvider.loginUser(email: email,
                                       password: password,
                                       queue: .main) { [weak self] (result) in
                                        switch result {
                                        case .success(let authToken):
                                            self?.output.loader(isShown: false)
                                            self?.defaultProvider.authToken = authToken
                                            self?.loginSucceed(authData: .email(email: email, password: password))
                                        case .failure(let error):
                                            self?.output.loader(isShown: false)
                                            self?.output.failToLogin(reason: error.localizedDescription)
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
