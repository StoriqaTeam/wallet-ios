//
//  Rate.swift
//  Wallet
//
//  Created by Даниил Мирошниченко on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


struct Rate {
    let criptoISO: String
    let toFiatISO: String
    let fiatValue: Decimal
    
}


// MARK: - RealmMappablee

extension Rate: RealmMappable {
    
    init(_ object: RealmRate) {
        self.criptoISO = object.cryptoISO
        self.toFiatISO = object.toFiatISO
        self.fiatValue = object.fiatValue.decimalValue()
    }
    
    func mapToRealmObject() -> RealmRate {
        let object = RealmRate()
        
        object.cryptoISO = self.criptoISO
        object.toFiatISO = self.toFiatISO
        object.fiatValue = self.fiatValue.string
        object.id = "\(self.criptoISO)-\(self.toFiatISO)"
        
        return object
    }
}



