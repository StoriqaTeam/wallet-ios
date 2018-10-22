//
//  Strings+Profile.swift
//  Wallet
//
//  Created by Tata Gri on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum Profile {
        static let changePhotoTitle = NSLocalizedString(
            "Profile.changePhotoTitle",
            tableName: "Profile",
            value: "Change profile photo",
            comment: "Change photo alert title")
        static let makePhotoButton = NSLocalizedString(
            "Profile.makePhotoButton",
            tableName: "Profile",
            value: "Make a photo",
            comment: "Make photo alert action title")
        static let fromGalleryButton = NSLocalizedString(
            "Profile.fromGalleryButton",
            tableName: "Profile",
            value: "Take from gallery",
            comment: "Take photo from gallery alert action title")
        static let cancelButton = NSLocalizedString(
            "Profile.cancelButton",
            tableName: "Profile",
            value: "Cancel",
            comment: "Cancel alert action title")
    }
}
