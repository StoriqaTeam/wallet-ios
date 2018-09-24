//
//  LoginLoginRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol LoginRouterInput: class {
    func showRegistration()
    func showPasswordRecovery(from viewController: UIViewController)
    func showQuickLaunch(authData: AuthData, token: String, from viewController: UIViewController)
    func showPinQuickLaunch(authData: AuthData, token: String, from viewController: UIViewController)
    func showAuthorizedZone()
}
