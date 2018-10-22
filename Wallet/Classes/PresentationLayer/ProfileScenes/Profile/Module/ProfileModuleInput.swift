//
//  ProfileModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ProfileModuleInput: class {
    var output: ProfileModuleOutput? { get set }
    var viewController: UIViewController { get }
    func present(from viewController: UIViewController)
}
