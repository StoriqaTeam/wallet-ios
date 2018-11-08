//
//  SettingsModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SettingsModuleInput: class {
    var viewController: UIViewController { get }
    var output: SettingsModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
