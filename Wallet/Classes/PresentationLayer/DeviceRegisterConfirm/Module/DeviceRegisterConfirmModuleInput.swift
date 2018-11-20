//
//  DeviceRegisterConfirmModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol DeviceRegisterConfirmModuleInput: class {
    var output: DeviceRegisterConfirmModuleOutput? { get set }
    func present()
}
