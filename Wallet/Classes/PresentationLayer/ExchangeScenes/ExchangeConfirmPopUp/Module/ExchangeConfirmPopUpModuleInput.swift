//
//  ExchangeConfirmPopUpModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ExchangeConfirmPopUpModuleInput: class {
    var output: ExchangeConfirmPopUpModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
