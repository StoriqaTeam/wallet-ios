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
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showFailure(message: String,
                     popUpDelegate: PopUpRegistrationFailedVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpRegistrationFailedVM(message: message)
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showSocialNetworkFailure(message: String, from viewController: UIViewController) {
        let viewModel = PopUpDefaultFailureVM(message: message)
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showLogin() {
        LoginModule.create(app: app).present()
    }
    
    func showQuickLaunch(from viewController: UIViewController) {
        QuickLaunchModule.create(app: app).present(from: viewController)
    }
    
    func showPinQuickLaunch(from viewController: UIViewController) {
        PinQuickLaunchModule.create(app: app).present(from: viewController)
    }
    
}
