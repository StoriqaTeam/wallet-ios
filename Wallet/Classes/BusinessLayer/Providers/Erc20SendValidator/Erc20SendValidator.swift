//
//  Erc20SendValidator.swift
//  Wallet
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol Erc20SendValidatorProtocol {
    func isValidAccount(_ account: Account) -> Bool
}

class Erc20SendValidator: Erc20SendValidatorProtocol {
    func isValidAccount(_ account: Account) -> Bool {
        guard account.currency == .stq else {
            return true
        }
        
        let erc20Approved = account.erc20Approved
        return erc20Approved
    }
}
