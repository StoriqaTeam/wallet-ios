//
//  AppInfoViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 28/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol AppInfoViewInput: class, Presentable {
    func setupInitialState(displayName: String,
                           bundleId: String,
                           appVersion: String)
}
