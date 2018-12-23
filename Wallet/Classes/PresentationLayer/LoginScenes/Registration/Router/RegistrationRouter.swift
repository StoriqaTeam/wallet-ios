//
//  RegistrationRegistrationRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class RegistrationRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
}


// MARK: - RegistrationRouterInput

extension RegistrationRouter: RegistrationRouterInput {
    func showSuccess(email: String,
                     popUpDelegate: PopUpRegistrationSuccessVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpRegistrationSuccessVM(email: email)
        viewModel.delegate = popUpDelegate
        let backBlur = captureScreen(view: viewController.view)
        PopUpModule.create(viewModel: viewModel, backImage: backBlur).present(from: viewController)
    }
    
    func showFailure(message: String,
                     popUpDelegate: PopUpRegistrationFailedVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpRegistrationFailedVM(message: message)
        viewModel.delegate = popUpDelegate
        let backBlur = captureScreen(view: viewController.view)
        PopUpModule.create(viewModel: viewModel, backImage: backBlur).present(from: viewController)
    }
    
    func showSocialNetworkFailure(message: String, from viewController: UIViewController) {
        let viewModel = PopUpDefaultFailureVM(message: message)
        let backBlur = captureScreen(view: viewController.view)
        PopUpModule.create(viewModel: viewModel, backImage: backBlur).present(from: viewController)
    }
    
    func showLogin(animated: Bool) {
        if animated {
            LoginModule.create(app: app).presentAnimated()
        } else {
            LoginModule.create(app: app).present()
        }
    }
    
    func showQuickLaunch(from viewController: UIViewController) {
        QuickLaunchModule.create(app: app).present(from: viewController)
    }
    
    func showPinQuickLaunch(from viewController: UIViewController) {
        PinQuickLaunchModule.create(app: app).present(from: viewController)
    }
    
    func showDeviceRegister(popUpDelegate: PopUpDeviceRegisterVMDelegate,
                            from viewController: UIViewController) {
        let viewModel = PopUpDeviceRegisterVM()
        viewModel.delegate = popUpDelegate
        let backBlur = captureScreen(view: viewController.view)
        PopUpModule.create(viewModel: viewModel, backImage: backBlur).present(from: viewController)
    }
    
    func showDeviceRegisterEmailSent(from viewController: UIViewController) {
        let viewModel = PopUpDeviceRegisterEmailSentVM()
        let backBlur = captureScreen(view: viewController.view)
        PopUpModule.create(viewModel: viewModel, backImage: backBlur).present(from: viewController)
    }
    
    func showDeviceRegisterFailedSendEmail(message: String,
                                           popUpDelegate: PopUpDeviceRegisterFailedSendEmailVMDelegate,
                                           from viewController: UIViewController) {
        let viewModel = PopUpDeviceRegisterFailedSendEmailVM(message: message)
        viewModel.delegate = popUpDelegate
        let backBlur = captureScreen(view: viewController.view)
        PopUpModule.create(viewModel: viewModel, backImage: backBlur).present(from: viewController)
    }
}
