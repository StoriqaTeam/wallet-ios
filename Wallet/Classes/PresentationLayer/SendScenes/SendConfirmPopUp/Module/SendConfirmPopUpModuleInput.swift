//
//  SendConfirmPopUpModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 14/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SendConfirmPopUpModuleInput: class {
    var output: SendConfirmPopUpModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
