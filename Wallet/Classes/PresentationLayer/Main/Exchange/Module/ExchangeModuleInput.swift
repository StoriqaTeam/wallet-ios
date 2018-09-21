//
//  ExchangeModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ExchangeModuleInput: class {
    var output: ExchangeModuleOutput? { get set }
    func present(from viewController: UIViewController)
    var viewController: UIViewController { get }
}
