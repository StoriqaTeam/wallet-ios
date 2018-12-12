//
//  Strings+PinInput.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    
    enum PinInput {
        static let greetingLabelTitle = NSLocalizedString("PinInput.greetingLabelTitle",
                                                          tableName: "PinInput",
                                                          value: "Hi, ",
                                                          comment: "Greeting label title")
        
        static let confirmPinResetMessage = NSLocalizedString("PinInput.confirmPinResetMessage",
                                                              tableName: "PinInput",
                                                              value: "Confirm PIN reset",
                                                              comment: "Confirm Pin reset alert message")
        
        static let resetPinAlertAction = NSLocalizedString("PinInput.resetPinAlertAction",
                                                           tableName: "PinInput",
                                                           value: "Reset PIN",
                                                           comment: "Reset Pin alert action title")
        
        static let cancelAlertAction = NSLocalizedString("PinInput.cancelAlertAction",
                                                         tableName: "PinInput",
                                                         value: "Cancel",
                                                         comment: "Cancel alert action title")
        
        static let touchIdFailedMessage = NSLocalizedString("PinInput.touchIdFailedMessage",
                                                            tableName: "PinInput",
                                                            value: "Touch ID failed",
                                                            comment: "Touch ID failed alert  title")
        
        
    }
}
