//
//  MyWalletInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class MyWalletInteractor {
    weak var output: MyWalletInteractorOutput!
    
    
    //FIXME: mock
    let accounts = [AccountModel(type: .stqBlack, cryptoAmount: "145,678,445.00", fiatAmount: "257,204.00 $", holderName: "Mushchinskii Dmitrii"),
                    AccountModel(type: .eth, cryptoAmount: "892.45", fiatAmount: "257,204.00 $", holderName: "Mushchinskii Dmitrii"),
                    AccountModel(type: .btc, cryptoAmount: "123.45", fiatAmount: "257,204.00 $", holderName: "Mushchinskii Dmitrii")]
}


// MARK: - MyWalletInteractorInput

extension MyWalletInteractor: MyWalletInteractorInput {
    
    func accountsCount() -> Int {
        return accounts.count
    }
    
    func accountModel(for index: Int) -> AccountModel? {
        guard accounts.count > index else {
                fatalError()
        }
        
        return accounts[index]
    }
    
}
