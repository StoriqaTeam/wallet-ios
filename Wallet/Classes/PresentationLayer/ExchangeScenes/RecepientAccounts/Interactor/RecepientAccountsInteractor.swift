//
//  RecipientAccountsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class RecipientAccountsInteractor {
    weak var output: RecipientAccountsInteractorOutput!
    
    private let exchangeProviderBuilder: ExchangeProviderBuilderProtocol
    private var exchangeProvider: ExchangeProviderProtocol
    
    init(exchangeProviderBuilder: ExchangeProviderBuilderProtocol) {
        self.exchangeProviderBuilder = exchangeProviderBuilder
        self.exchangeProvider = exchangeProviderBuilder.build()
    }
}


// MARK: - RecipientAccountsInteractorInput

extension RecipientAccountsInteractor: RecipientAccountsInteractorInput {
    func setSelected(account: Account) {
        exchangeProviderBuilder.set(recipientAccount: account)
    }
    
    func getAccounts() -> [Account] {
        return exchangeProvider.getRecipientAccounts()
    }
}
