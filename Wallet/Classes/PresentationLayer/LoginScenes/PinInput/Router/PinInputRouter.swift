//
//  PinInputPasswordInputRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PinInputRouter {

}


// MARK: - PinInputRouterInput

extension PinInputRouter: PinInputRouterInput {
    func showLogin() {
        LoginModule.create().present()
    }
    
    func showMainTabBar() {
        MainTabBarModule.create().present()
    }
}
