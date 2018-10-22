//
//  ConnectPhoneViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ConnectPhoneViewInput: class, Presentable {
    func setupInitialState(phone: String, buttonTitle: String)
    func setConnectButtonEnabled(_ enabled: Bool)
}
