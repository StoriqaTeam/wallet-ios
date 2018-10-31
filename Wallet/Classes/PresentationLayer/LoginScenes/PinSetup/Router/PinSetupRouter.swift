//
//  PinSetupRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PinSetupRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - PinSetupRouterInput

extension PinSetupRouter: PinSetupRouterInput {
    func showAuthorizedZone() {
        MainTabBarModule.create(app: app).present()
    }
    
    func showBiometryQuickLaunch(qiuckLaunchProvider: QuickLaunchProviderProtocol, from viewController: UIViewController) {
        BiometryQuickLaunchModule.create(app: app, qiuckLaunchProvider: qiuckLaunchProvider).present(from: viewController)
    }
    
}
