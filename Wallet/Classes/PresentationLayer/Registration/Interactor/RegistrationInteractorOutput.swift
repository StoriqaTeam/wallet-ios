//
//  RegistrationRegistrationInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RegistrationInteractorOutput: class {
    func registrationSucceed(email: String)
    func registrationFailed(message: String)
    
    //TODO: we don't know the structure of api errors yet
    func registrationFailed(apiErrors: [ResponseAPIError.Message])
    
    func setFormIsValid(_ valid: Bool, passwordsEqualityMessage: String?)
}
