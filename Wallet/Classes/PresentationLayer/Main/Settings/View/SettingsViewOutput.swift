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
    func willMoveToParentVC()
    func viewWillAppear()
    func viewDidAppear()
    func editProfileSelected()
    func changePhoneSelected()
    func changePasswordSelected()
    func sessionSelected()
}
