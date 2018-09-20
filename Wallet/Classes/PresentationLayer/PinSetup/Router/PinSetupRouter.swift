//
//  PinSetupRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PinSetupRouter {

}


// MARK: - PinSetupRouterInput

extension PinSetupRouter: PinSetupRouterInput {
    func showAuthorizedZone() {
        //TODO: showAuthorizedZone
        log.debug("TODO: showAuthorizedZone")
    }
    
    func showBiometryQuickLaunch(qiuckLaunchProvider: QuickLaunchProviderProtocol, from viewController: UIViewController) {
        BiometryQuickLaunchModule.create(qiuckLaunchProvider: qiuckLaunchProvider).present(from: viewController)
    }
    
}
