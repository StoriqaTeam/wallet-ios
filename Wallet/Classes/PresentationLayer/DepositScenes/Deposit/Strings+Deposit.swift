//
//  Strings+Deposit.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum Deposit {
        static let navigationBarTitle = NSLocalizedString(
            "Deposit.navigationBarTitle",
            tableName: "Deposit",
            value: "Deposit to account",
            comment: "Navigation bar title")
        
        static let addressTitle = NSLocalizedString(
            "Deposit.addressTitle",
            tableName: "Deposit",
            value: "Your address",
            comment: "Address title")

        static let copyButton = NSLocalizedString(
            "Deposit.copyButton",
            tableName: "Deposit",
            value: "Copy",
            comment: "Copy button title")

        static let qrCodeTitle = NSLocalizedString(
            "Deposit.qrCodeTitle",
            tableName: "Deposit",
            value: "QR-CODE FOR TRANSACTION",
            comment: "QR-code title")

        static let shareButton = NSLocalizedString(
            "Deposit.shareButton",
            tableName: "Deposit",
            value: "Tap & hold to share",
            comment: "Share button title")
        
        static let addressCopiedMessage = NSLocalizedString(
            "Deposit.addressCopiedMessage",
            tableName: "Deposit",
            value: "Address copied to clipboard",
            comment: "Address copied to clipboard message")
    }
}
