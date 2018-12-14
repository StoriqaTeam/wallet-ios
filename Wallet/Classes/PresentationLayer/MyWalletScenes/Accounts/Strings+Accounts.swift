//
//  Strings+Accounts.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum Accounts {
        private static let tableName = "Accounts"
        static let sendButton = NSLocalizedString(
            "Accounts.sendButton",
            tableName: tableName,
            value: "Send",
            comment: "Send button on account screen. Routes to send screen")
        static let depositButton = NSLocalizedString(
            "Accounts.depositButton",
            tableName: tableName,
            value: "Deposit",
            comment: "Deposit button on account screen. Routes to deposit screen")
        static let exchangeButton = NSLocalizedString(
            "Accounts.exchangeButton",
            tableName: tableName,
            value: "Change",
            comment: "Change button on account screen. Routes to change screen")
        static let lastTransactionsTitle = NSLocalizedString(
            "Accounts.lastTransactionsTitle",
            tableName: tableName,
            value: "Last transactions",
            comment: "Last transactions table header")
        static let viewAllButton = NSLocalizedString(
            "Accounts.viewAllButton",
            tableName: tableName,
            value: "View all",
            comment: "View all button")
    }
}
