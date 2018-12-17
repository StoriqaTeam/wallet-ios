//
//  Strings+SendConfirmPopUp.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


extension Strings {
    
    enum SendConfirmPopUp {
        private static let tableName = "SendConfirmPopUp"

        static let screenTitle = NSLocalizedString(
            "SendConfirmPopUp.screenTitle",
            tableName: tableName,
            value: "Confirm sending money",
            comment: "Screen title. Displaying below the icon.")

        static let addressTitle = NSLocalizedString(
            "SendConfirmPopUp.addressTitle",
            tableName: tableName,
            value: "Address",
            comment: "Address title")

        static let amountTitle = NSLocalizedString(
            "SendConfirmPopUp.amountTitle",
            tableName: tableName,
            value: "Amount",
            comment: "Amount title")

        static let feeTitle = NSLocalizedString(
            "SendConfirmPopUp.feeTitle",
            tableName: tableName,
            value: "Transaction fee",
            comment: "Transaction fee title")

        static let confirmButton = NSLocalizedString(
            "SendConfirmPopUp.confirmButton",
            tableName: tableName,
            value: "Confirm transaction",
            comment: "Confirm transaction button title")

        static let closeButton = NSLocalizedString(
            "SendConfirmPopUp.closeButton",
            tableName: tableName,
            value: "Close",
            comment: "Close button title")

    }
    
}