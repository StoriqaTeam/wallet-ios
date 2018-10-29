//
//  PinQuickLaunchRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PinQuickLaunchRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - PinQuickLaunchRouterInput

extension PinQuickLaunchRouter: PinQuickLaunchRouterInput {
    
    func showPinSetup(qiuckLaunchProvider: QuickLaunchProviderProtocol, from viewController: UIViewController) {
        PinSetupModule.create(app: app, qiuckLaunchProvider: qiuckLaunchProvider).present(from: viewController)
    }
    
    func showAuthorizedZone() {
        MainTabBarModule.create(app: app).present()
    }
    
    func showBiometryQuickLaunch(qiuckLaunchProvider: QuickLaunchProviderProtocol, from viewController: UIViewController) {
        BiometryQuickLaunchModule.create(app: app, qiuckLaunchProvider: qiuckLaunchProvider).present(from: viewController)
    }
    
}
