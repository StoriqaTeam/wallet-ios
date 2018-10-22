//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PasswordRecoveryConfirmModuleInput: class {
    var output: PasswordRecoveryConfirmModuleOutput? { get set }
    func present(from viewController: UIViewController)
    func present()
}
