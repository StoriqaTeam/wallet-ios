//
//  LoginLoginViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol LoginViewOutput: class {
    func viewIsReady()
    func showRegistration()
    func showPasswordRecovery()
    func socialNetworkRegisterFailed(tokenProvider: SocialNetworkTokenProvider)
    func signIn(email: String, password: String)
    func signIn(tokenProvider: SocialNetworkTokenProvider, token: String, email: String)
}
