//
//  RecipientAccountsModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol RecipientAccountsModuleInput: class {
    var output: RecipientAccountsModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
