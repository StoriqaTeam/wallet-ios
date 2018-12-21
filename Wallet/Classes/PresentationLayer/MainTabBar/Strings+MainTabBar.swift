//
//  Strings+MainTabBar.swift
//  Wallet
//
//  Created by Storiqa on 21/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum MainTabBar {
        static let wallet = NSLocalizedString("MainTabBar.wallet",
                                              tableName: "MainTabBar",
                                              value: "Wallet",
                                              comment: "Wallet tab title")
        static let deposit = NSLocalizedString("MainTabBar.deposit",
                                               tableName: "MainTabBar",
                                               value: "Deposit",
                                               comment: "Deposit tab title")
        static let menu = NSLocalizedString("MainTabBar.menu",
                                            tableName: "MainTabBar",
                                            value: "Menu",
                                            comment: "Menu tab title")
        static let send = NSLocalizedString("MainTabBar.send",
                                            tableName: "MainTabBar",
                                            value: "Send",
                                            comment: "Send tab title")
        static let exchange = NSLocalizedString("MainTabBar.exchange",
                                            tableName: "MainTabBar",
                                            value: "Exchange",
                                            comment: "Exchange tab title")
    }
}
