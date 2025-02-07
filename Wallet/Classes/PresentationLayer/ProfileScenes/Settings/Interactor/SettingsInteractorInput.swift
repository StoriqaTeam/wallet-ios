//
//  SettingsInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SettingsInteractorInput: class {
    func deleteAppData()
    func userHasPhone() -> Bool
    func userLoginedWithSocialProvider() -> Bool
}
