//
//  RecepientAccountsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class RecepientAccountsInteractor {
    weak var output: RecepientAccountsInteractorOutput!
    
    private let exchangeProviderBuilder: ExchangeProviderBuilderProtocol
    private var exchangeProvider: ExchangeProviderProtocol
    
    init(exchangeProviderBuilder: ExchangeProviderBuilderProtocol) {
        self.exchangeProviderBuilder = exchangeProviderBuilder
        self.exchangeProvider = exchangeProviderBuilder.build()
    }
}


// MARK: - RecepientAccountsInteractorInput

extension RecepientAccountsInteractor: RecepientAccountsInteractorInput {
    func setSelected(account: Account) {
        exchangeProviderBuilder.set(recepientAccount: account)
    }
    
    func getAccounts() -> [Account] {
        return exchangeProvider.getRecepientAccounts()
    }
}
