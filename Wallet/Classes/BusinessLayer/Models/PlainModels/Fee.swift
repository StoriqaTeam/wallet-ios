//
//  Fee.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct Fee {
    let fromCurrency: Currency
    let toCurrency: Currency
    let fees: [FeeAndWait]
}

extension Fee: RealmMappable {
    init(_ object: RealmFee) {
        self.fromCurrency = Currency(string: object.fromCurrency)
        self.toCurrency = Currency(string: object.toCurrency)
        self.fees = object.fees.map { FeeAndWait($0) }
    }
    
    func mapToRealmObject() -> RealmFee {
        let object = RealmFee()
        
        object.fromCurrency = self.fromCurrency.ISO
        object.toCurrency = self.toCurrency.ISO
        object.id = object.fromCurrency + object.toCurrency
        object.fees.append(objectsIn: self.fees.map { $0.mapToRealmObject() })
        
        return object
    }
    
    init?(json: JSON, fromCurrency: Currency, toCurrency: Currency) {
        guard let feesArray = json["fees"].array else {
            return nil
        }
        
        let fees = feesArray.compactMap { FeeAndWait(json: $0) }
        
        guard !fees.isEmpty else {
            return nil
        }
        
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.fees = fees
    }
}
