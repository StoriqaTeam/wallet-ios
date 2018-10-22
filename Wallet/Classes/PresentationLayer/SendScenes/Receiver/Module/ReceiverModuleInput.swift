//
//  ReceiverModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ReceiverModuleInput: class {
    var output: ReceiverModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
