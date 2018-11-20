//
//  DeviceRegisterConfirmRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class DeviceRegisterConfirmRouter {

    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
    
}


// MARK: - DeviceRegisterConfirmRouterInput

extension DeviceRegisterConfirmRouter: DeviceRegisterConfirmRouterInput {
    func showSuccess(popUpDelegate: PopUpConfirmDeviceRegisterSucceedVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpConfirmDeviceRegisterSucceedVM()
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
