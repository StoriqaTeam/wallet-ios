//
//  SettingsRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SettingsRouter {

}


// MARK: - SettingsRouterInput

extension SettingsRouter: SettingsRouterInput {
    func showEditProfile(from viewController: UIViewController) {
        EditProfileModule.create().present(from: viewController)
    }
    
    func showChangePhone(from viewController: UIViewController) {
        ConnectPhoneModule.create().present(from: viewController)
    }
    
    func showChangePassword(from viewController: UIViewController) {
        // TODO: change password module
    }
    
    func showLogin() {
        LoginModule.create().present()
    }
}
