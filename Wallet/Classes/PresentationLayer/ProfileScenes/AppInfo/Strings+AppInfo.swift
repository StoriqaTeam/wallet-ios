//
//  Strings+AppInfo.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum AppInfo {
        static let navigationBarTitle = NSLocalizedString(
            "AppInfo.navigationBarTitle",
            tableName: "AppInfo",
            value: "App info",
            comment: "Navigation bar title")
        
        static let displayNameTitle = NSLocalizedString(
            "AppInfo.displayNameTitle",
            tableName: "AppInfo",
            value: "Name",
            comment: "App name title")

        static let appVersionTitle = NSLocalizedString(
            "AppInfo.appVersionTitle",
            tableName: "AppInfo",
            value: "App version",
            comment: "App version title")

        static let bundleIdTitle = NSLocalizedString(
            "AppInfo.bundleIdTitle",
            tableName: "AppInfo",
            value: "Bundle ID",
            comment: "Bundle ID title")

    }
}
