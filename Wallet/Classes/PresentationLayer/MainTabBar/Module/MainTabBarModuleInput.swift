//
//  MainTabBarModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol MainTabBarModuleInput: class {
    var output: MainTabBarModuleOutput? { get set }
    func present(from viewController: UIViewController)
    func present()
}
