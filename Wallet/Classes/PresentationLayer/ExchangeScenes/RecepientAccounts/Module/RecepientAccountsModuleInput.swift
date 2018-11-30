//
//  RecepientAccountsModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol RecepientAccountsModuleInput: class {
    var output: RecepientAccountsModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
