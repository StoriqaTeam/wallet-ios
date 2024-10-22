//
//  SettingsViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SettingsViewInput: class, Presentable {
    func setupInitialState(hasChangePassword: Bool)
    func setChangePhoneTitle(_ title: String)
}
