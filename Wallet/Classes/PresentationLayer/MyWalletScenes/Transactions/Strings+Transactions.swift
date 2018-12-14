//
//  Strings+Transactions.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum Transactions {
        static let navigationBarTitle = NSLocalizedString(
            "Transactions.navigationBarTitle",
            tableName: "Transactions",
            value: "Transactions",
            comment: "Navigation bar title on transactions screen")
        static let allButton = NSLocalizedString(
            "Transactions.allButton",
            tableName: "Transactions",
            value: "All",
            comment: "Button to choose displaying all transactions")
        static let sentButton = NSLocalizedString(
            "Transactions.sentButton",
            tableName: "Transactions",
            value: "Sent",
            comment: "Button to choose displaying sent transactions")
        static let receivedButton = NSLocalizedString(
            "Transactions.receivedButton",
            tableName: "Transactions",
            value: "Received",
            comment: "Button to choose displaying received transactions")
    }
}
