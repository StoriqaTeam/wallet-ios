//
//  Rate.swift
//  Wallet
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


struct Rate {
    let fromISO: String
    let toISO: String
    let value: Decimal
}


// MARK: - RealmMappablee

extension Rate: RealmMappable {
    
    init(_ object: RealmRate) {
        self.fromISO = object.fromISO
        self.toISO = object.toISO
        self.value = object.fiatValue.decimalValue()
    }
    
    func mapToRealmObject() -> RealmRate {
        let object = RealmRate()
        
        object.fromISO = self.fromISO
        object.toISO = self.toISO
        object.fiatValue = self.value.string
        object.id = "\(self.fromISO)-\(self.toISO)"
        
        return object
    }
}
