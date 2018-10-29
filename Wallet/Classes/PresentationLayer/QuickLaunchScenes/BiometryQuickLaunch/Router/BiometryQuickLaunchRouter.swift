//
//  BiometryQuickLaunchRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class BiometryQuickLaunchRouter {
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
}


// MARK: - BiometryQuickLaunchRouterInput

extension BiometryQuickLaunchRouter: BiometryQuickLaunchRouterInput {
    
    func showAuthorizedZone() {
        MainTabBarModule.create(app: app).present()
    }
    
}
