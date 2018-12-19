//
//  Strings+EditProfile.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


extension Strings {
    enum EditProfile {
        static let navigationBarTitle = NSLocalizedString(
            "EditProfile.navigationBarTitle",
            tableName: "EditProfile",
            value: "Edit profile",
            comment: "Screen title")
        
        static let personalInfoTitle = NSLocalizedString(
            "EditProfile.personalInfoTitle",
            tableName: "EditProfile",
            value: "PERSONAL INFORMATION",
            comment: "Input title")
        
        static let firstNamePlaceholder = NSLocalizedString(
            "EditProfile.firstNamePlaceholder",
            tableName: "EditProfile",
            value: "First name",
            comment: "First name input placeholder")
        
        static let lastNamePlaceholder = NSLocalizedString(
            "EditProfile.lastNamePlaceholder",
            tableName: "EditProfile",
            value: "Last name",
            comment: "Last name input placeholder")
        
        static let saveButton = NSLocalizedString(
            "EditProfile.saveButton",
            tableName: "EditProfile",
            value: "Save",
            comment: "Save button title")
    }
}
