//
//  Strings+QuickLaunch.swift
//  Wallet
//
//  Created by Storiqa on 08/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum QuickLaunch {
        static let cancelButtonTitle = NSLocalizedString("QuickLaunch.cancelButtonTitle",
                                                         tableName: "QuickLaunch",
                                                         value: "Do not use",
                                                         comment: "Cancel button title")
        
        static let quickLaunchTitle = NSLocalizedString("QuickLaunch.quickLaunchTitle",
                                                        tableName: "QuickLaunch",
                                                        value: "Set up quick launch",
                                                        comment: "Quick launch title label")
        static let quickLaunchSubtitle = NSLocalizedString("QuickLaunch.quickLaunchSubtitle",
                                                           tableName: "QuickLaunch",
                                                           value: "Choose the way to confirm your identity",
                                                           comment: "Quick launch subtitle label")
        
        static let setUpButtonTitle = NSLocalizedString("QuickLaunch.setUpButtonTitle",
                                                        tableName: "QuickLaunch",
                                                        value: "Set up quick launch",
                                                        comment: "Set up quick launch button title")
        
    }
}

