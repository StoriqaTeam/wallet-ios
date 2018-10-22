//
//  EditProfileModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol EditProfileModuleInput: class {
    var output: EditProfileModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
