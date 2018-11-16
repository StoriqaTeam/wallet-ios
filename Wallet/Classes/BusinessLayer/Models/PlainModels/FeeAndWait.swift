//
//  FeeAndWait.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct FeeAndWait {
    let value: Decimal
    let estimatedTime: Int
}

extension FeeAndWait: RealmMappable {
    init(_ object: RealmFeeAndWait) {
        self.value = object.value.decimalValue()
        self.estimatedTime = object.estimatedTime
    }
    
    func mapToRealmObject() -> RealmFeeAndWait {
        let object = RealmFeeAndWait()
        
        object.value = self.value.string
        object.estimatedTime = self.estimatedTime
        
        return object
    }
    
    init?(json: JSON) {
        guard let value = json["value"].int,
            let estimatedTime = json["estimatedTime"].int else {
                return nil
        }
        
        self.value = Decimal(value)
        self.estimatedTime = estimatedTime
    }
}
