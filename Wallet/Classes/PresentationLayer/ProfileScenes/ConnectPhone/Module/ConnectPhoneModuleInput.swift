//
//  ConnectPhoneModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ConnectPhoneModuleInput: class {
    var output: ConnectPhoneModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
