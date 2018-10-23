//
//  FirstLaunchFirstLaunchRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class FirstLaunchRouter {

}


// MARK: - FirstLaunchRouterInput

extension FirstLaunchRouter: FirstLaunchRouterInput {
    func showLogin() {
        LoginModule.create().present()
    }
    
    func showRegistration() {
        RegistrationModule.create().present()
    }
}
