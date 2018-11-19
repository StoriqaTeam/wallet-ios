//
//  RecepientAccountsInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RecepientAccountsInteractorInput: class {
    func getAccounts() -> [Account]
    func setSelected(account: Account)
}
