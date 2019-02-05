//
//  Strings+ExchangeConfirmPopUp.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    
    enum ExchangeConfirmPopUp {
        private static let tableName = "ExchangeConfirmPopUp"
        
        static let screenTitle = NSLocalizedString(
            "ExchangeConfirmPopUp.screenTitle",
            tableName: tableName,
            value: "Confirm exchanging",
            comment: "Screen title. Displaying below the icon.")
        
        static let fromTitle = NSLocalizedString(
            "ExchangeConfirmPopUp.fromTitle",
            tableName: tableName,
            value: "From",
            comment: "From title")
        
        static let toTitle = NSLocalizedString(
            "ExchangeConfirmPopUp.toTitle",
            tableName: tableName,
            value: "To",
            comment: "To title")
        
         static let confirmButton = NSLocalizedString(
            "ExchangeConfirmPopUp.confirmButton",
            tableName: tableName,
            value: "Confirm",
            comment: "Confirm transaction button title")
        
        static let closeButton = NSLocalizedString(
            "ExchangeConfirmPopUp.closeButton",
            tableName: tableName,
            value: "Cancel",
            comment: "Close button title")
        
    }
    
}
