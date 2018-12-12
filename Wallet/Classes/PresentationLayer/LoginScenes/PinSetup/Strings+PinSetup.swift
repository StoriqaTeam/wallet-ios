//
//  Strings+PinSetup.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


extension Strings {
    
    enum PinSetup {
        static let enterPinTitle = NSLocalizedString("PinSetup.enterPinTitle",
                                                     tableName: "PinSetup",
                                                     value: "Enter 4-digit PIN",
                                                     comment: "Pin setup view title")
        static let confirmPinTitle = NSLocalizedString("PinSetup.confirmPinTitle",
                                                       tableName: "PinSetup",
                                                       value: "Confirm PIN",
                                                       comment: "Confirm Pin view title")
        static let pinNotMatchAlert = NSLocalizedString("PinSetup.pinNotMatchAlert",
                                                        tableName: "PinSetup",
                                                        value: "Codes do not match. Try again.",
                                                        comment: "Pin do not match alert message")
    }
}
