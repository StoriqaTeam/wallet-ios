//
//  EmailConfirmRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class EmailConfirmRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - EmailConfirmRouterInput

extension EmailConfirmRouter: EmailConfirmRouterInput {
    func showSuccess(popUpDelegate: PopUpEmailConfirmSuccessVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpEmailConfirmSuccessVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showFailure(message: String,
                     popUpDelegate: PopUpEmailConfirmFailedVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpEmailConfirmFailedVM(message: message)
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showLogin() {
        LoginModule.create(app: app).present()
    }
}
