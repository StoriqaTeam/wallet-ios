//
//  TransactionDetailsInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransactionDetailsInteractorInput: class {
    func getTransaction() -> Transaction
}
