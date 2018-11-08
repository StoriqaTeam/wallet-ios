//
//  QuickLaunchRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class QuickLaunchRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - QuickLaunchRouterInput

extension QuickLaunchRouter: QuickLaunchRouterInput {
    
    func showPinQuickLaunch(qiuckLaunchProvider: QuickLaunchProviderProtocol, from viewController: UIViewController) {
        PinSetupModule.create(app: app, qiuckLaunchProvider: qiuckLaunchProvider).present(from: viewController)
    }
    
}
