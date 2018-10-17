//
//  PinInputPasswordInputViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PinInputViewInput: class, Presentable {
    func setupInitialState(userPhoto: UIImage, userName: String)
    func inputSucceed()
    func inputFailed()
    func clearInput()
    func showAlert(title: String, message: String)
}
