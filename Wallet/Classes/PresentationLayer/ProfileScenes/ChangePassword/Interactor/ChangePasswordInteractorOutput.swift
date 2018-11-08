//
//  ChangePasswordInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ChangePasswordInteractorOutput: class {
    func changePasswordSucceed()
    func changePasswordFailed(message: String)
    func formValidationFailed(oldPassword: String?, newPassword: String?)
}
