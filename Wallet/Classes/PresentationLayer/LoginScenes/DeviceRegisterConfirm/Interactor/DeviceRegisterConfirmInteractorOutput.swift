//
//  DeviceRegisterConfirmInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol DeviceRegisterConfirmInteractorOutput: class {
    func confirmationSucceed()
    func confirmationFailed(message: String)
}
