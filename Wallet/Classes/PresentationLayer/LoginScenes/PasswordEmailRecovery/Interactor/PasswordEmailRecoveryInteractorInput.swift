//
//  PasswordEmailRecoveryPasswordEmailRecoveryInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PasswordEmailRecoveryInteractorInput: class {
    func resetPassword(email: String)
    func retry()
}
