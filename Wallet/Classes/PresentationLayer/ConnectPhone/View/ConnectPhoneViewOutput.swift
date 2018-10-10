//
//  ConnectPhoneViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ConnectPhoneViewOutput: class {
    func viewIsReady()
    func willMoveToParentVC()
    func isValidPhoneNumber(_ phone: String) -> Bool
    func connectButtonPressed(_ phone: String)
    func cancelButtonPressed()
}
