//
//  TransactionDetailsModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionDetailsModuleInput: class {
    var output: TransactionDetailsModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
