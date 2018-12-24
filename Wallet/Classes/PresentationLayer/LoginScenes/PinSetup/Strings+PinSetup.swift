//
//  Strings+PinSetup.swift
//  Wallet
//
//  Created by Storiqa on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


extension Strings {
    
    enum PinSetup {
        static let enterPinTitle = NSLocalizedString("PinSetup.enterPinTitle",
                                                     tableName: "PinSetup",
                                                     value: "Set up PIN-code",
                                                     comment: "Pin setup view title")
        
        static let confirmPinTitle = NSLocalizedString("PinSetup.confirmPinTitle",
                                                       tableName: "PinSetup",
                                                       value: "Confirm PIN-code",
                                                       comment: "Confirm Pin view title")
        
        static let enterPinSubtitle = NSLocalizedString("PinSetup.enterPinSubtitle",
                                                     tableName: "PinSetup",
                                                     value: "Enter 4-digit PIN",
                                                     comment: "Pin setup view subtitle")
        
        static let confirmPinSubtitle = NSLocalizedString("PinSetup.confirmPinSubtitle",
                                                       tableName: "PinSetup",
                                                       value: "Enter your PIN once more",
                                                       comment: "Confirm Pin view subtitle")
        
        static let pinNotMatchAlert = NSLocalizedString("PinSetup.pinNotMatchAlert",
                                                        tableName: "PinSetup",
                                                        value: "PINs do not match. Try again.",
                                                        comment: "Pin do not match alert message")
    }
}
