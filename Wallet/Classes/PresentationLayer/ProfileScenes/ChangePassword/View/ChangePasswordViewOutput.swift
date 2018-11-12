//
//  ChangePasswordViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ChangePasswordViewOutput: class {
    func viewIsReady()
    func viewWillAppear()
    func validateFields(currentPassword: String?,
                        newPassword: String?,
                        repeatPassword: String?)
    func validateNewPassword(onEndEditing: Bool,
                             _ newPassword: String?,
                             _ repeatPassword: String?)
    func changePassword(currentPassword: String,
                        newPassword: String)
}
