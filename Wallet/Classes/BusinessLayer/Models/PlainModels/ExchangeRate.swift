//
//  ExchangeRate.swift
//  Wallet
//
//  Created by Storiqa on 09/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import Foundation

struct ExchangeRate {
    let id: String
    let from: Currency
    let to: Currency
    let rate: Decimal
    let amount: Decimal
    let expiration: Date
    let createdAt: Date
    let updatedAt: Date
}


extension ExchangeRate {
    
    init?(json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormats.txDateString
        
        guard let id = json["id"].string,
            let from = json["from"].string,
            let to = json["to"].string,
            let rateDouble = json["rate"].double,
            let amountDouble = json["amount"].double,
            let createdAt = json["createdAt"].string,
            let expiration = json["expiration"].string,
            let updatedAt = json["updatedAt"].string else { return nil }
        
        guard let createdDate = dateFormatter.date(from: createdAt),
            let updatedDate = dateFormatter.date(from: updatedAt),
            let expirationDate = dateFormatter.date(from: expiration) else { return nil }
        
        self.id = id
        self.from = Currency(string: from)
        self.to = Currency(string: to)
        self.amount = Decimal(amountDouble)
        self.rate = Decimal(rateDouble)
        self.createdAt = createdDate
        self.updatedAt = updatedDate
        self.expiration = expirationDate
    }
}
