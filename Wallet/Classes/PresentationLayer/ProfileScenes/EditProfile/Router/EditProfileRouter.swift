//
//  EditProfileRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class EditProfileRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - EditProfileRouterInput

extension EditProfileRouter: EditProfileRouterInput {
    func showFailure(message: String,
                     from viewController: UIViewController) {
        let viewModel = PopUpDefaultFailureVM(message: message)
        let backBlur = captureScreen(view: viewController.view)
        PopUpModule.create(viewModel: viewModel, backImage: backBlur).present(from: viewController)
    }
}
