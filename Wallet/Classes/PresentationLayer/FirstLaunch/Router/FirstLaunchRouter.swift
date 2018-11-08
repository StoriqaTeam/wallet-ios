//
//  FirstLaunchFirstLaunchRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class FirstLaunchRouter {
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
}


// MARK: - FirstLaunchRouterInput

extension FirstLaunchRouter: FirstLaunchRouterInput {
    func showLogin() {
        LoginModule.create(app: app).present()
    }
    
    func showRegistration() {
        RegistrationModule.create(app: app).present()
    }
}
