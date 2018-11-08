//
//  ChangePasswordInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ChangePasswordInteractorInput: class {
    func changePassword(currentPassword: String, newPassword: String)
}
