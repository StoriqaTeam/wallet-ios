//
//  MyWalletModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol MyWalletModuleInput: class {
    var output: MyWalletModuleOutput? { get set }
    var viewController: UIViewController { get }
    func present(from viewController: UIViewController)
}
