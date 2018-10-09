//
//  ProfileRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ProfileRouter {

}


// MARK: - ProfileRouterInput

extension ProfileRouter: ProfileRouterInput {
    
    func signOut() {
        LoginModule.create().present()
    }
    
    func showSettings(from viewController: UIViewController) {
        SettingsModule.create().present(from: viewController)
    }
    
}
