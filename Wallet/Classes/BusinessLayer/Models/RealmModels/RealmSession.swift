//
//  RealmSession.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class RealmSession: Object {
    dynamic var date: Double = 0
    dynamic var device: String = ""
}
