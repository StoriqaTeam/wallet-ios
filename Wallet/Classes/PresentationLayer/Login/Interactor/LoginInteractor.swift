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
    
    init(socialViewVM: SocialNetworkAuthViewModel, defaultProvider: DefaultsProviderProtocol) {
        self.socialViewVM = socialViewVM
        self.defaultProvider = defaultProvider
    }
    
}


// MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {
    
    func getSocialVM() -> SocialNetworkAuthViewModel {
        return socialViewVM
    }
    
    func signIn(email: String, password: String) {
        //TODO: implement in new provider
        log.warn("implement login provider")
        
        // FIXME: - stub
        if arc4random_uniform(2) == 0 {
            if !defaultProvider.isQuickLaunchShown {
                output.showQuickLaunch(authData: .email(email: email, password: password), token: "")
            } else {
                output.loginSucceed()
            }
        } else {
            output.loginFailed(message: Constants.Errors.userFriendly)
        }
        // ------------------------------
        
        
    }
    
    func signIn(tokenProvider: SocialNetworkTokenProvider, socialNetworkToken: String) {
        //TODO: implement in new provider
        log.warn("implement login provider")
        
        // FIXME: - stub
        if arc4random_uniform(2) == 0 {
            if !defaultProvider.isQuickLaunchShown {
                output.showQuickLaunch(authData: .socialProvider(provider: tokenProvider, token: socialNetworkToken), token: "")
            } else {
                output.loginSucceed()
            }
        } else {
            output.loginFailed(message: Constants.Errors.userFriendly)
        }
        // ------------------------------
    }
}
