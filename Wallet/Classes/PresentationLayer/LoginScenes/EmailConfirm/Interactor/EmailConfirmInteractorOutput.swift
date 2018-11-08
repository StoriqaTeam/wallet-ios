//
//  EmailConfirmInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol EmailConfirmInteractorOutput: class {
    func confirmationSucceed()
    func confirmationFailed(message: String)
}
