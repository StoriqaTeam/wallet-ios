//
//  LoginLoginRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class LoginRouter {
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
}

// MARK: - LoginRouterInput

extension LoginRouter: LoginRouterInput {
    func showFailurePopup(message: String, popUpDelegate: PopUpRegistrationFailedVMDelegate, from viewController: UIViewController) {
        let viewModel = PopUpRegistrationFailedVM(message: message)
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showPasswordRecovery(from viewController: UIViewController) {
        PasswordEmailRecoveryModule.create(app: app).present(from: viewController)
    }
    
    func showRegistration() {
        RegistrationModule.create(app: app).present()
    }
    
    func showQuickLaunch(authData: AuthData, token: String, from viewController: UIViewController) {
        QuickLaunchModule.create(app: app, authData: authData, token: token).present(from: viewController)
    }
    
    func showPinQuickLaunch(authData: AuthData, token: String, from viewController: UIViewController) {
        PinQuickLaunchModule.create(app: app, authData: authData, token: token).present(from: viewController)
    }
    
    func showAuthorizedZone() {
        MainTabBarModule.create(app: app).present()
    }
}
