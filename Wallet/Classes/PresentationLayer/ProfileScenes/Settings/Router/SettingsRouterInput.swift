//
//  SettingsRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SettingsRouterInput: class {
    func showEditProfile(from viewController: UIViewController)
    func showChangePhone(from viewController: UIViewController)
    func showChangePassword(from viewController: UIViewController)
    func showSessions(from viewController: UIViewController)
}
