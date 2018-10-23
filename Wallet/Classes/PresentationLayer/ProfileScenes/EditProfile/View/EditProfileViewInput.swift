//
//  EditProfileViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol EditProfileViewInput: class, Presentable {
    func setupInitialState(firstName: String, lastName: String)
    func setButtonEnabled(_ enabled: Bool)
}
