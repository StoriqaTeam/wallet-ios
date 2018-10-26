//
//  TransactionFilterModuleModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionFilterModuleInput: class {
    var output: TransactionFilterModuleOutput? { get set }
    func present(from viewController: UIViewController)
}