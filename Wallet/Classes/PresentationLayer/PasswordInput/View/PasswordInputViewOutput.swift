//
//  PasswordInputPasswordInputViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PasswordInputViewOutput: class {
    func viewIsReady()
    func setPasswordView(in stackView: UIStackView) -> PasswordContainerView
    func passwordInputComplete(_ password: String)
}
