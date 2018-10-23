//
//  SessionsModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SessionsModuleInput: class {
    var output: SessionsModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
