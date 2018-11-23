//
//  ConnectPhoneInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ConnectPhoneInteractorOutput: class {
    func userUpdatedSuccessfully()
    func userUpdateFailed(message: String)
}
