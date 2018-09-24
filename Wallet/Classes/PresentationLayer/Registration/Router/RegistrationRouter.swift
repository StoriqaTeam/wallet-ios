//
//  RegistrationRegistrationRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class RegistrationRouter {

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
        let viewModel = PopUpSocialRegistrationFailedVM(message: message)
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showAuthorizedZone() {
        MainTabBarModule.create().present()
    }
    
    
    func showLogin() {
        LoginModule.create().present()
    }
    
}
