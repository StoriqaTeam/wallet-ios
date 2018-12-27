//
//  Strings+TransactionDetails.swift
//  Wallet
//
//  Created by Storiqa on 13/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum TransactionDetails {
        static let addressCopiedMessage = NSLocalizedString(
            "TransactionDetails.addressCopiedMessage",
            tableName: "TransactionDetails",
            value: "Address copied to clipboard",
            comment: "Shown when address is copied to clipboard")
        
        static let navigationBarTitleDeposit = NSLocalizedString(
            "TransactionDetails.navigationBarTitleDeposit",
            tableName: "TransactionDetails",
            value: "Received transaction",
            comment: "Navigation bar title when transaction is received")
        
        static let navigationBarTitleSent = NSLocalizedString(
            "TransactionDetails.navigationBarTitleSent",
            tableName: "TransactionDetails",
            value: "Sent transaction",
            comment: "Navigation bar title when transaction is sent")
        
        static let viewOnExplorer = NSLocalizedString(
            "TransactionDetails.viewOnExplorer",
            tableName: "TransactionDetails",
            value: "View on ",
            comment: "View transaction on explorer link")
        
        static let fromLabel = NSLocalizedString(
            "TransactionDetails.fromLabel",
            tableName: "TransactionDetails",
            value: "From",
            comment: "From label")
        
        static let toLabel = NSLocalizedString(
            "TransactionDetails.toLabel",
            tableName: "TransactionDetails",
            value: "To",
            comment: "To label")
    }
}
