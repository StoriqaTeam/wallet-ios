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
}
