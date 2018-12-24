//
//  PasswordEmailRecoveryPasswordEmailRecoveryRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PasswordEmailRecoveryRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
    
}


// MARK: - PasswordEmailRecoveryRouterInput

extension PasswordEmailRecoveryRouter: PasswordEmailRecoveryRouterInput {
    
    func showSuccess(popUpDelegate: PopUpPasswordEmailRecoverySuccessVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpPasswordEmailRecoverySuccessVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showFailure(message: String, popUpDelegate: PopUpPasswordEmailRecoveryFailedVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpPasswordEmailRecoveryFailedVM(message: message)
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
    
    func showEmailSengingFailure(message: String,
                                 from viewController: UIViewController) {
        let viewModel = PopUpDefaultFailureVM(message: message)
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
}
