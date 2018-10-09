//
//  TransactionMapper.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class TransactionMapper: Mappable {
    
    typealias FromObj = Transaction
    typealias ToObj = TransactionDisplayable
    
    func map(from obj: Transaction) -> TransactionDisplayable {
        fatalError("Stub")
    }
}
