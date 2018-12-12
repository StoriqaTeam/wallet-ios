//
//  Strings+Send.swift
//  Wallet
//
//  Created by Storiqa on 22/10/2018.
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
        
        static let notEnoughFundsErrorMessage = NSLocalizedString(
            "Send.notEnoughFundsErrorMessage",
            tableName: "Send",
            value: "You haven’t got enough funds. Try to set lower amount.",
            comment: "Not enough funds error message")
        
        static let recepientAddressTitle = NSLocalizedString(
            "Send.recepientAddressTitle",
            tableName: "Send",
            value: "RECEPIENT'S ADDRESS",
            comment: "Recepient address label title")
        
        static let recepientInputPlaceholder = NSLocalizedString(
            "Send.recepientAddressTitle",
            tableName: "Send",
            value: "Recepient's address",
            comment: "Recepient address label placeholder")
        
        static let scanButtonTitle = NSLocalizedString(
            "Send.scanButtonTitle",
            tableName: "Send",
            value: "Scan QR-code",
            comment: "Scan Qr button title")
        
        static let nonExistAddressTitle = NSLocalizedString(
            "Send.nonExistAddressTitle",
            tableName: "Send",
            value: "Address is non-existent",
            comment: "Address non-exist label text")
        
        static let freeFeeLabel = NSLocalizedString(
            "Send.freeFeeLabel",
            tableName: "Send",
            value: "FREE",
            comment: "Free fee label text")
        
        
        static let exceedDayLimitMessage = NSLocalizedString(
            "Send.exceedDayLimitMessage",
            tableName: "Send",
            value: "You’ve exceeded you daily transaction limit of %@ for this account.",
            comment: "Exceed dayly limit message")
        
        
    }
}
