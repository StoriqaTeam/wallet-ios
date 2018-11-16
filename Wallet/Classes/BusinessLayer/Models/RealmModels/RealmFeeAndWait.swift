//
//  RealmFeeAndWait.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers
class RealmFeeAndWait: Object {
    dynamic var value: String  = ""
    dynamic var estimatedTime: Int = 0
}
