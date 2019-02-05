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
        
        static let recipientAddressTitle = NSLocalizedString(
            "Send.recipientAddressTitle",
            tableName: "Send",
            value: "Recipient's address",
            comment: "Recipient address label title")
        
        static let recipientInputPlaceholder = NSLocalizedString(
            "Send.recipientAddressTitle",
            tableName: "Send",
            value: "Enter address here",
            comment: "Recipient address label placeholder")
        
        static let amountTitle = NSLocalizedString(
            "Send.amountTitle",
            tableName: "Send",
            value: "Amount",
            comment: "Amount input title")
        
        static let amountPlaceholder = NSLocalizedString(
            "Send.amountPlaceholder",
            tableName: "Send",
            value: "Enter amount in %@",
            comment: "Amount input placeholder")
        
        static let fiatAmountTitle = NSLocalizedString(
            "Send.fiatAmountTitle",
            tableName: "Send",
            value: "Equivalent amount in %@",
            comment: "Amount input title")
        
        static let fiatAmountPlaceholder = NSLocalizedString(
            "Send.fiatAmountPlaceholder",
            tableName: "Send",
            value: "Enter amount in %@",
            comment: "Amount input placeholder")
        
        static let feeTitle = NSLocalizedString(
            "Send.feeTitle",
            tableName: "Send",
            value: "Fee",
            comment: "Payment fee title")
        
        static let medianWaitTitle = NSLocalizedString(
            "Send.medianWaitTitle",
            tableName: "Send",
            value: "Estimated time",
            comment: "Median wait title")

        static let lowFee = NSLocalizedString(
            "Send.lowFee",
            tableName: "Send",
            value: "Low",
            comment: "Low fee slider position label")

        static let highFee = NSLocalizedString(
            "Send.highFee",
            tableName: "Send",
            value: "High",
            comment: "High fee slider position label")

        static let sendButton = NSLocalizedString(
            "Send.sendButton",
            tableName: "Send",
            value: "Send",
            comment: "Send button title")
        
        static let notEnoughFundsErrorMessage = NSLocalizedString(
            "Send.notEnoughFundsErrorMessage",
            tableName: "Send",
            value: "You don't have enough funds. \nTry to set lower amount.",
            comment: "Not enough funds error message")
        
        static let nonExistAddressTitle = NSLocalizedString(
            "Send.nonExistAddressTitle",
            tableName: "Send",
            value: "Address is non-existent",
            comment: "Address non-exist label text")
        
        static let exceedDayLimitMessage = NSLocalizedString(
            "Send.exceedDayLimitMessage",
            tableName: "Send",
            value: "You’ve exceeded you daily transaction limit of %@ for this account.",
            comment: "Exceed dayly limit message")
    }
}
