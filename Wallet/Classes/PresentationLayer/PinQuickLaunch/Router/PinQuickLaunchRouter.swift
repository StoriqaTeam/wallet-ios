//
//  PinQuickLaunchRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PinQuickLaunchRouter {

}


// MARK: - PinQuickLaunchRouterInput

extension PinQuickLaunchRouter: PinQuickLaunchRouterInput {
    
    func showPinSetup(qiuckLaunchProvider: QuickLaunchProviderProtocol, from viewController: UIViewController) {
        //TODO: show pin setup
        log.debug("TODO: show pin setup")
    }
    
    func showAuthorizedZone() {
        //TODO: showAuthorizedZone
        log.debug("TODO: showAuthorizedZone")
    }
    
    func showBiometryQuickLaunch(qiuckLaunchProvider: QuickLaunchProviderProtocol, from viewController: UIViewController) {
        BiometryQuickLaunchModule.create(qiuckLaunchProvider: qiuckLaunchProvider).present(from: viewController)
    }
    
}
