//
//  Strings+ConnectPhone.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


extension Strings {
    enum ConnectPhone {
        static let navigationBarConnectTitle = NSLocalizedString(
            "ConnectPhone.navigationBarConnectTitle",
            tableName: "ConnectPhone",
            value: "Connect",
            comment: "Screen title in case if connect mode")
        
        static let navigationBarChangeTitle = NSLocalizedString(
            "ConnectPhone.navigationBarChangeTitle",
            tableName: "ConnectPhone",
            value: "Change",
            comment: "Screen title in case if change mode")
        
        static let screenSubtitle = NSLocalizedString(
            "ConnectPhone.screenSubtitle",
            tableName: "ConnectPhone",
            value: "You can link phone number to protect your account.",
            comment: "Shown on the top of the screen")
        
        static let phoneNumberPlaceholder = NSLocalizedString(
            "ConnectPhone.phoneNumberPlaceholder",
            tableName: "ConnectPhone",
            value: "Phone number",
            comment: "Phone number input placeholder")
        
        static let phoneNumberHint = NSLocalizedString(
            "ConnectPhone.phoneNumberHint",
            tableName: "ConnectPhone",
            value: "Enter your number starting with country code. Example for US: +1-541-754-3010",
            comment: "Phone number input hint")
        
        static let connetButton = NSLocalizedString(
            "ConnectPhone.connetButton",
            tableName: "ConnectPhone",
            value: "Connect phone number",
            comment: "Connect button title")
        
        static let changeButton = NSLocalizedString(
            "ConnectPhone.changeButton",
            tableName: "ConnectPhone",
            value: "Change phone number",
            comment: "Change button title")
    }
}
