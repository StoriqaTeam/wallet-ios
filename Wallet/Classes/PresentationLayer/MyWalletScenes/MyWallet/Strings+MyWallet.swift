//
//  Strings+MyWallet.swift
//  Wallet
//
//  Created by Storiqa on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum MyWallet {
        static let navigationBarTitle = NSLocalizedString("MyWallet.navigationBarTitle",
                                                          tableName: "MyWallet",
                                                          value: "Accounts",
                                                          comment: "Navigation bar title on my wallet screen")
        static let buttonTitle = NSLocalizedString("MyWallet.buttonTitle",
                                                   tableName: "MyWallet",
                                                   value: "Add new",
                                                   comment: "Button at the right side of navigation bar")
        static let newFundsReceivedMessage = NSLocalizedString("MyWallet.newFundsReceivedMessage",
                                                               tableName: "MyWallet",
                                                               value: "You received ",
                                                               comment: "Notification message abount new received funds")
        static let addNewAccountButton = NSLocalizedString("MyWallet.addNewAccountButton",
                                                           tableName: "MyWallet",
                                                           value: "+ Add new account",
                                                           comment: "Add new account button")
    }
}
