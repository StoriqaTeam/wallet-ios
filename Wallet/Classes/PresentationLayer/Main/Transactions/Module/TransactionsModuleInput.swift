//
//  TransactionsModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionsModuleInput: class {
    var output: TransactionsModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
