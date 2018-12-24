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
    
    func showQuickLaunch() {
        QuickLaunchModule.create(app: app).presentAsTansitioningNavigationController()
    }
    
    func showPinQuickLaunch() {
        PinQuickLaunchModule.create(app: app).present()
    }
    
    func showAuthorizedZone() {
        MainTabBarModule.create(app: app).present()
    }
    
    func showDeviceRegister(popUpDelegate: PopUpDeviceRegisterVMDelegate,
                            from viewController: UIViewController) {
        let viewModel = PopUpDeviceRegisterVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showDeviceRegisterEmailSent(from viewController: UIViewController) {
        let viewModel = PopUpDeviceRegisterEmailSentVM()
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showDeviceRegisterFailedSendEmail(message: String,
                                           popUpDelegate: PopUpDeviceRegisterFailedSendEmailVMDelegate,
                                           from viewController: UIViewController) {
        let viewModel = PopUpDeviceRegisterFailedSendEmailVM(message: message)
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showEmailNotVerified(popUpDelegate: PopUpResendConfirmEmailVMDelegate,
                              from viewController: UIViewController) {
        let viewModel = PopUpResendConfirmEmailVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showEmailSengingSuccess(email: String,
                                 popUpDelegate: PopUpRegistrationSuccessVMDelegate,
                                 from viewController: UIViewController) {
        let viewModel = PopUpRegistrationSuccessVM(email: email)
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showFailure(message: String,
                     from viewController: UIViewController) {
        let viewModel = PopUpDefaultFailureVM(message: message)
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
}
