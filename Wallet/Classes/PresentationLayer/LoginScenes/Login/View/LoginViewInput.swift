//
//  LoginLoginViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol LoginViewInput: class, Presentable {
    func setupInitialState()
    func setSocialView(viewModel: SocialNetworkAuthViewModel)
    func showErrorMessage(email: String?, password: String?)
    func setAnimatedApperance()
}
