//
//  EstimatedFee.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


struct EstimatedFee {
    let currency: Currency
    let value: Decimal // in min units
    let estimatedTime: Int // in seconds
    
    init?(json: JSON, currency: Currency) {
        guard let value = json["value"].string,
        let estimatedTime = json["estimatedTime"].int else {
            return nil
        }
        
        self.value = value.decimalValue()
        self.estimatedTime = estimatedTime
        self.currency = currency
    }
}
