//
//  ChangePasswordRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ChangePasswordRouter {

}


// MARK: - ChangePasswordRouterInput

extension ChangePasswordRouter: ChangePasswordRouterInput {
    func showSuccess(popUpDelegate: PopUpChangePasswordSuccessVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpChangePasswordSuccessVM()
        viewModel.delegate = popUpDelegate
        let backBlur = captureScreen(view: viewController.view)
        PopUpModule.create(viewModel: viewModel, backImage: backBlur).present(from: viewController)
    }
    
    func showFailure(message: String,
                     from viewController: UIViewController) {
        let viewModel = PopUpDefaultFailureVM(message: message)
        let backBlur = captureScreen(view: viewController.view)
        PopUpModule.create(viewModel: viewModel, backImage: backBlur).present(from: viewController)
    }
    
}
