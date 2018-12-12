//
//  Strings+Exchange.swift
//  Wallet
//
//  Created by Tata Gri on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum Exchange {
        static let amountTitle = NSLocalizedString(
            "Exchange.amountTitle",
            tableName: "Exchange",
            value: "AMOUNT",
            comment: "Amount input title")
        static let amountPlaceholder = NSLocalizedString(
            "Exchange.amountPlaceholder",
            tableName: "Exchange",
            value: "Enter amount",
            comment: "Amount input placeholder")
    }
}
