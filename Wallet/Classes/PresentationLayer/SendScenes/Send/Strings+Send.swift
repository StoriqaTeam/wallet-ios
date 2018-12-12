//
//  Strings+Send.swift
//  Wallet
//
//  Created by Tata Gri on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum Send {
        static let screenTitle = NSLocalizedString(
            "Send.screenTitle",
            tableName: "Send",
            value: "Send",
            comment: "Send screen title")
        static let headerTitle = NSLocalizedString(
            "Send.headerTitle",
            tableName: "Send",
            value: "SENDING",
            comment: "Title of gradient header in send module")
        static let amountTitle = NSLocalizedString(
            "Send.amountTitle",
            tableName: "Send",
            value: "AMOUNT",
            comment: "Amount input title")
        static let amountPlaceholder = NSLocalizedString(
            "Send.amountPlaceholder",
            tableName: "Send",
            value: "Enter amount",
            comment: "Amount input placeholder")
        static let receiverCurrencyTitle = NSLocalizedString(
            "Send.receiverCurrencyTitle",
            tableName: "Send",
            value: "RECEIVER CURRENCY",
            comment: "Receiver currency title")
    }
}
