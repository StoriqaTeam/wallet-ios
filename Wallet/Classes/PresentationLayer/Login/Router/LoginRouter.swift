//
//  LoginLoginRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class LoginRouter {

}

// MARK: - LoginRouterInput

extension LoginRouter: LoginRouterInput {
    func showPasswordRecovery(from viewController: UIViewController) {
        PasswordEmailRecoveryModule.create().present(from: viewController)
    }
    
    func showRegistration() {
        RegistrationModule.create().present()
    }
    
    func showQuickLaunch(authData: AuthData, token: String, from viewController: UIViewController) {
        QuickLaunchModule.create(authData: authData, token: token).present(from: viewController)
    }
    
    func showPinQuickLaunch(authData: AuthData, token: String, from viewController: UIViewController) {
        PinQuickLaunchModule.create(authData: authData, token: token).present(from: viewController)
    }
    
}
