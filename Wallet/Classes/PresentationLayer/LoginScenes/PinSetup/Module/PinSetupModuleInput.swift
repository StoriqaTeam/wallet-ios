//
//  PinSetupModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PinSetupModuleInput: class {
    var output: PinSetupModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
