//
//  LoginLoginModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol LoginModuleInput: class {
    var output: LoginModuleOutput? { get set }
    func present()
    func presentAnimated()
}
