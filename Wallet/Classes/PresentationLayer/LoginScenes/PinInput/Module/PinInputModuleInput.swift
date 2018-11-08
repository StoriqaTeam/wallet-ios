//
//  PinInputPasswordInputModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PinInputModuleInput: class {
    var output: PinInputModuleOutput? { get set }
    func present(from viewController: UIViewController)
    func presentModal(from viewController: UIViewController)
    func present()
}
