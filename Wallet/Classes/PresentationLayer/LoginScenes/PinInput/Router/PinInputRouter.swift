//
//  PinInputPasswordInputRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PinInputRouter {
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
}


// MARK: - PinInputRouterInput

extension PinInputRouter: PinInputRouterInput {
    func showLogin() {
        LoginModule.create(app: app).present()
    }
    
    func showMainTabBar() {
        MainTabBarModule.create(app: app).present()
    }
}
