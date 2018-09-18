//
//  RegistrationRegistrationInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RegistrationInteractorInput: class {
    func validateForm(_ form: RegistrationForm)
    func register(firstName: String, lastName: String, email: String, password: String)
}
