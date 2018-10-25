//
//  TransactionAccount.swift
//  Wallet
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


struct TransactionAccount {
    let accountId: String
    let ownerName: String
}


// MARK: - RealmMappablee

extension TransactionAccount: RealmMappable {
    typealias RealmType = RealmTransactionAccount
    
    init(_ object: RealmType) {
        self.accountId = object.accountId
        self.ownerName = object.ownerName
    }
    
    func mapToRealmObject() -> RealmTransactionAccount {
        let object = RealmTransactionAccount()
        
        object.accountId = self.accountId
        object.ownerName = self.ownerName
        
        return object
    }
    
}
