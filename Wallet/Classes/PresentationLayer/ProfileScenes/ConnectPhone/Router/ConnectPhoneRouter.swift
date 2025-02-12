//
//  ConnectPhoneRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ConnectPhoneRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - ConnectPhoneRouterInput

extension ConnectPhoneRouter: ConnectPhoneRouterInput {
    func showFailure(message: String, from viewController: UIViewController) {
        let viewModel = PopUpDefaultFailureVM(message: message)
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
}
