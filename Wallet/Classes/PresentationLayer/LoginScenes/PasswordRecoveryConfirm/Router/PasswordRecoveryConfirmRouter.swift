//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PasswordRecoveryConfirmRouter {
    
    private let app: Application

    init(app: Application) {
        self.app = app
    }
}


// MARK: - PasswordRecoveryConfirmRouterInput

extension PasswordRecoveryConfirmRouter: PasswordRecoveryConfirmRouterInput {
    
    func showSuccess(popUpDelegate: PopUpPasswordRecoveryConfirmSuccessVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpPasswordRecoveryConfirmSuccessVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showFailure(message: String,
                     popUpDelegate: PopUpPasswordRecoveryConfirmFailedVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpPasswordRecoveryConfirmFailedVM(message: message)
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showLogin() {
        LoginModule.create(app: app).present()
    }
    
}
