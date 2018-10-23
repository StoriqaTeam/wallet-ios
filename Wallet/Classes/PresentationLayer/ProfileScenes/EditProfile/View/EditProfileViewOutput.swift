//
//  EditProfileViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol EditProfileViewOutput: class {
    func viewIsReady()
    func saveButtonTapped(firstName: String, lastName: String)
    func valuesChanged(firstName: String?, lastName: String?)
}
