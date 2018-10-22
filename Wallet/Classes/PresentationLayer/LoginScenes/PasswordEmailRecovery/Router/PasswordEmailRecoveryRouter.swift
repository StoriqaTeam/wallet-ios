//
//  PasswordEmailRecoveryPasswordEmailRecoveryRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PasswordEmailRecoveryRouter {
    
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
    
}
