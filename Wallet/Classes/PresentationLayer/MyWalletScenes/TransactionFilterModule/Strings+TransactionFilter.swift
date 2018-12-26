//
//  Strings+TransactionFilter.swift
//  Wallet
//
//  Created by Storiqa on 13/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    
    enum TransactionFilter {
        private static let tableName = "TransactionFilter"
        
        static let navigationTitle = NSLocalizedString(
            "TransactionFilter.navigationTitle",
            tableName: tableName,
            value: "Transaction Filter",
            comment: "Navigation bar title on transaction filter screen")
        static let fromPlaceholder = NSLocalizedString(
            "TransactionFilter.fromPlaceholder",
            tableName: tableName,
            value: "From",
            comment: "From text field placeholder")
        static let toPlaceholder = NSLocalizedString(
            "TransactionFilter.toPlaceholder",
            tableName: tableName,
            value: "To",
            comment: "To text field placeholder")
        static let okButton = NSLocalizedString(
            "TransactionFilter.okButton",
            tableName: tableName,
            value: "OK",
            comment: "Ok button title")
        static let clearButtonTitle = NSLocalizedString(
            "TransactionFilter.clearButtonTitle",
            tableName: tableName,
            value: "Clear filter",
            comment: "Clear filter button title")
        static let dateLabel = NSLocalizedString(
            "TransactionFilter.dateLabel",
            tableName: tableName,
            value: "DATE",
            comment: "Date label above input fields")
        static let description = NSLocalizedString(
            "TransactionFilter.description",
            tableName: tableName,
            value: "Select a period",
            comment: "Screen description above input fields")
    }
    
}
