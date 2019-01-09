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
            value: "Confirm sending",
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
        
        static let totalTitle = NSLocalizedString(
            "SendConfirmPopUp.totalTitle",
            tableName: tableName,
            value: "Total to send",
            comment: "Total to send title")
        
        static let freeFeeLabel = NSLocalizedString(
            "SendConfirmPopUp.freeFeeLabel",
            tableName: tableName,
            value: "Free",
            comment: "Free fee label text")

        static let confirmButton = NSLocalizedString(
            "SendConfirmPopUp.confirmButton",
            tableName: tableName,
            value: "Confirm",
            comment: "Confirm transaction button title")

        static let closeButton = NSLocalizedString(
            "SendConfirmPopUp.closeButton",
            tableName: tableName,
            value: "Cancel",
            comment: "Close button title")

    }
    
}
