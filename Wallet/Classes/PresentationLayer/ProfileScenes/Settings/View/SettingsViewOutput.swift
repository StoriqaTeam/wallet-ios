//
//  SettingsViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SettingsViewOutput: class {
    func viewIsReady()
    func editProfileSelected()
    func changePasswordSelected()
    func changePhoneNumber()
    func signOutButtonTapped()
    func viewWillAppear()
    func appInfoSelected()
}
