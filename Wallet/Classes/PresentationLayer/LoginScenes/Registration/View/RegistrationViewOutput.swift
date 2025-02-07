//
//  RegistrationRegistrationViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol RegistrationViewOutput: class {
    func viewIsReady()
    func register(firstName: String, lastName: String, email: String, password: String)
    func validateFields(firstName: String?,
                        lastName: String?,
                        email: String?,
                        password: String?,
                        repeatPassword: String?,
                        agreement: Bool,
                        privacy: Bool)
    func validatePasswords(onEndEditing: Bool, password: String?, repeatPassword: String?)
    func showLogin()
    func socialNetworkRegisterSucceed(provider: SocialNetworkTokenProvider, token: String, email: String)
    func socialNetworkRegisterFailed(tokenProvider: SocialNetworkTokenProvider)
}
