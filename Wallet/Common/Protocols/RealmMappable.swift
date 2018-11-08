//
//  RealmMappable.swift
//  Wallet
//
//  Created by Storiqa on 01/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import RealmSwift


protocol RealmMappable {
    associatedtype RealmType: Object
    init(_ object: RealmType)
    func mapToRealmObject() -> RealmType
}
