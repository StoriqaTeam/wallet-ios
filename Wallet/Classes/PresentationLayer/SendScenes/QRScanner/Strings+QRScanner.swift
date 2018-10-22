//
//  Strings+QRScanner.swift
//  Wallet
//
//  Created by Tata Gri on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum QRScanner {
        static let screenTitle = NSLocalizedString(
            "QRScanner.screenTitle",
            tableName: "QRScanner",
            value: "Scan QR-code",
            comment: "QR scanner screen title")
        static let defaultHintMessage = NSLocalizedString(
            "QRScanner.defaultHintMessage",
            tableName: "QRScanner",
            value: "Place QR-code inside white frame. Try not to shake your phone",
            comment: "Message shown on QR scanner screen by default")
        static let currenciesDoNotMatch = NSLocalizedString(
            "QRScanner.currenciesDoNotMatch",
            tableName: "QRScanner",
            value: "Currency of scanned address doesn't match previously selected receiver currency.",
            comment: "Message shown when scanned currency does not match selected receiver currency")
        static let okButton = NSLocalizedString( 
            "QRScanner.okButton",
            tableName: "QRScanner",
            value: "Ok",
            comment: "Ok button in alert when camera not available")
    }
}
