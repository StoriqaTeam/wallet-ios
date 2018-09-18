//
//  RegistrationRegistrationViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol RegistrationViewInput: class, Presentable {
    func setupInitialState()
    func showSuccess(email: String)
    func showError(message: String)
    func setButtonEnabled(_ enabled: Bool)
    func showPasswordsNotEqual(message: String?)
    
    //TODO: we don't know the structure of api errors yet
    func showApiErrors(_ apiErrors: [ResponseAPIError.Message])
}
