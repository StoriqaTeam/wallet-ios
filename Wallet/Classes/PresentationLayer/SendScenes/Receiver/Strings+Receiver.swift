//
//  Strings+Receiver.swift
//  Wallet
//
//  Created by Tata Gri on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum Receiver {
        static let screenTitle = NSLocalizedString(
            "Receiver.screenTitle",
            tableName: "Receiver",
            value: "Receiver",
            comment: "Receiver screen title")
        static let noSuchNumberPlaceholder = NSLocalizedString(
            "Receiver.noSuchNumberPlaceholder",
            tableName: "Receiver",
            value: "There is no such number in system.\nUse another way to send funds.",
            comment: "Message in case of empty search result in contact list")
        static let emptyListPlaceholder = NSLocalizedString(
            "Receiver.emptyListPlaceholder",
            tableName: "Receiver",
            value: "Contact list is empty",
            comment: "Message in case of empty contact list")
        static let sendToInputTitle = NSLocalizedString(
            "Receiver.sendToInputTitle",
            tableName: "Receiver",
            value: "SEND TO",
            comment: "Send screen input title")
        static let sendToInputPlaceholder = NSLocalizedString(
            "Receiver.sendToInputPlaceholder",
            tableName: "Receiver",
            value: "Wallet address or phone number",
            comment: "Send screen input placeholder")
        static let scanQRButton = NSLocalizedString(
            "Receiver.scanQRButton",
            tableName: "Receiver",
            value: "Scan QR-code",
            comment: "Scan QR-code button title")
        static let nextButton = NSLocalizedString(
            "Receiver.nextButton",
            tableName: "Receiver",
            value: "Next",
            comment: "Next button title")
    }
}
