//
//  EmailConfirmModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol EmailConfirmModuleInput: class {
    var output: EmailConfirmModuleOutput? { get set }
    func present()
}
