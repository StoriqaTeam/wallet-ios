//
//  SettingsRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SettingsRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - SettingsRouterInput

extension SettingsRouter: SettingsRouterInput {
    func showEditProfile(from viewController: UIViewController) {
        EditProfileModule.create(app: app).present(from: viewController)
    }
    
    func showChangePassword(from viewController: UIViewController) {
        ChangePasswordModule.create(app: app).present(from: viewController)
    }
    
    func signOut() {
        LoginModule.create(app: app).present()
    }
    
    func signOutConfirmPopUp(popUpDelegate: PopUpSignOutVMDelegate, from viewController: UIViewController) {
        let viewModel = PopUpSignOutVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
}
