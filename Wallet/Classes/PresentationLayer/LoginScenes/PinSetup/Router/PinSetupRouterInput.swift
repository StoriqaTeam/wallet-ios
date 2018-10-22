//
//  PinSetupRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PinSetupRouterInput: class {
    func showAuthorizedZone()
    func showBiometryQuickLaunch(qiuckLaunchProvider: QuickLaunchProviderProtocol, from viewController: UIViewController)
}
