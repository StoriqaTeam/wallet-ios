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
        
        static let fromAmountTitle = NSLocalizedString(
            "Exchange.fromAmountTitle",
            tableName: "Exchange",
            value: "From",
            comment: "From amount input title")
        
        static let toAmountTitle = NSLocalizedString(
            "Exchange.toAmountTitle",
            tableName: "Exchange",
            value: "To",
            comment: "To amount input title")
        
        static let amountPlaceholder = NSLocalizedString(
            "Exchange.amountPlaceholder",
            tableName: "Exchange",
            value: "Enter amount in %@",
            comment: "From amount input placeholder")
        
        static let exchangeButton = NSLocalizedString(
            "Exchange.exchangeButton",
            tableName: "Exchange",
            value: "Exchange",
            comment: "Exchange button title")
        
        static let notEnoughFundsErrorLabel = NSLocalizedString(
            "Exchange.notEnoughFundsErrorLabel",
            tableName: "Exchange",
            value: "You don't have enough funds. Try to set lower amount.",
            comment: "Not enough error label text")

        static let exceedDayLimitMessage = NSLocalizedString(
            "Send.exceedDayLimitMessage",
            tableName: "Send",
            value: "You’ve exceeded you daily transaction limit of %@ for this account.",
            comment: "Exceed dayly limit message")

        static let amountOutOfBounds = NSLocalizedString(
            "Exchange.amountOutOfBounds",
            tableName: "Exchange",
            value: "Transaction amount should be between %@ and %@.",
            comment: "Transaction amount out of bounds message")
    }
}
