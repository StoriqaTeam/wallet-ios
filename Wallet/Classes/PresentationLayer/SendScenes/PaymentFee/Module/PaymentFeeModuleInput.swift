//
//  PaymentFeeModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PaymentFeeModuleInput: class {
    var output: PaymentFeeModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
