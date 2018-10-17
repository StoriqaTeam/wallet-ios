//
//  PinQuickLaunchModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PinQuickLaunchModuleInput: class {
    var output: PinQuickLaunchModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
