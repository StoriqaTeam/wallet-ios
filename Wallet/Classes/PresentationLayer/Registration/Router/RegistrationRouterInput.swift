//
//  RegistrationRegistrationRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol RegistrationRouterInput: class {
    func showLogin()
    func showSuccess(email: String, from viewController: UIViewController)
    func showFailure(message: String, from viewController: UIViewController)
}
