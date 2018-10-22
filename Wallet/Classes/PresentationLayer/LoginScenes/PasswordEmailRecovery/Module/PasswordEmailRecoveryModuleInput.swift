//
//  PasswordEmailRecoveryPasswordEmailRecoveryModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PasswordEmailRecoveryModuleInput: class {
    var output: PasswordEmailRecoveryModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
