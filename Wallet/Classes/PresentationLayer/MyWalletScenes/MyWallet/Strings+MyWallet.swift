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
        static let buttonTitle = NSLocalizedString("MyWallet.buttonTitle",
                                                   tableName: "MyWallet",
                                                   value: "Add new",
                                                   comment: "Button at the right side of navigation bar")
        static let navBarTitle = NSLocalizedString("MyWallet.navBarTitle",
                                                   tableName: "MyWallet",
                                                   value: "My wallet",
                                                   comment: "Navigation bar title")
    }
}
