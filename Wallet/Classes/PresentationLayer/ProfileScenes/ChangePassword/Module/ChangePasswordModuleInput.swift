//
//  ChangePasswordModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ChangePasswordModuleInput: class {
    var output: ChangePasswordModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
