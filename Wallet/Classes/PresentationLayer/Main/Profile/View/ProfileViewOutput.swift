//
//  ProfileViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ProfileViewOutput: class {
    func viewIsReady()
    func settingsButtonTapped()
    func connectPhoneButtonTapped()
    func signOutButtonTapped()
    func changePhoneButtonTapped()
    func photoTapped()
}
