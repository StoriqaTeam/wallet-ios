//
//  AppInfoModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 28/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol AppInfoModuleInput: class {
    var output: AppInfoModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
