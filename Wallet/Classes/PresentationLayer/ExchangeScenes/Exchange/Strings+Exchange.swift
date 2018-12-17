//
//  Strings+Exchange.swift
//  Wallet
//
//  Created by Storiqa on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum Exchange {
        static let navigationBarTitle = NSLocalizedString(
            "Exchange.navigationBarTitle",
            tableName: "Exchange",
            value: "Exchange",
            comment: "Navigation bar title")
        
        static let amountTitle = NSLocalizedString(
            "Exchange.amountTitle",
            tableName: "Exchange",
            value: "AMOUNT",
            comment: "Amount input title")
        
        static let toAccountTitle = NSLocalizedString(
            "Exchange.toAccountTitle",
            tableName: "Exchange",
            value: "TO ACCOUNT",
            comment: "To account input title")
        
        static let subtotalTitle = NSLocalizedString(
            "Exchange.subtotalTitle",
            tableName: "Exchange",
            value: "SUBTOTAL TO SEND",
            comment: "Subtotal title input title")
        
        static let amountPlaceholder = NSLocalizedString(
            "Exchange.amountPlaceholder",
            tableName: "Exchange",
            value: "Enter amount",
            comment: "Amount input placeholder")
        
        static let exchangeButton = NSLocalizedString(
            "Exchange.exchangeButton",
            tableName: "Exchange",
            value: "Exchange",
            comment: "Exchange button title")
        
        static let notEnoughFundsErrorLabel = NSLocalizedString(
            "Exchange.notEnoughFundsErrorLabel",
            tableName: "Exchange",
            value: "You haven’t got enough funds. Try to set lower amount.",
            comment: "Not enough error label text")
        
        static let noAccountsAvailable = NSLocalizedString(
            "Exchange.noAccountsAvailable",
            tableName: "Exchange",
            value: "No accounts available",
            comment: "Shown when user has only one account. Will never be shown, only in case of emerjency")

        static let balanceLabel = NSLocalizedString(
            "Exchange.balanceLabel",
            tableName: "Exchange",
            value: "Balance: %@",
            comment: "Label shown with recepient account balance")

        static let exceedDayLimitMessage = NSLocalizedString(
            "Send.exceedDayLimitMessage",
            tableName: "Send",
            value: "You’ve exceeded you daily transaction limit of %@ for this account.",
            comment: "Exceed dayly limit message")

        static let amountOutOfBounds = NSLocalizedString(
            "Exchange.amountOutOfBounds",
            tableName: "Exchange",
            value: "Transaction amount should be between %@ and %@",
            comment: "Transaction amount out of bounds message")
    }
}