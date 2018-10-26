//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionsModule {
    
    class func create(account: Account) -> TransactionsModuleInput {
        let router = TransactionsRouter()
        
        let dataStoreService = AccountsDataStore()
        let accountsProvider = AccountsProvider(dataStoreService: dataStoreService)
        let currencyFormatter = CurrencyFormatter()
        let converterFactory = CurrecncyConverterFactory()
        let transactionDirectionResolver = TransactionDirectionResolver(accountsProvider: accountsProvider)
        let contactsDataStoreService = ContactsDataStoreService()
        let contactsProvider = ContactsProvider(dataStoreService: contactsDataStoreService)
        let contactsMapper = ContactsMapper()
        let transactionOpponentResolver = TransactionOpponentResolver(
            contactsProvider: contactsProvider,
            transactionDirectionResolver: transactionDirectionResolver,
            contactsMapper: contactsMapper)
        let transactionMapper = TransactionMapper(currencyFormatter: currencyFormatter,
                                                  converterFactory: converterFactory,
                                                  transactionDirectionResolver: transactionDirectionResolver,
                                                  transactionOpponentResolver: transactionOpponentResolver)
        let transactionDataStoreService = TransactionDataStoreService()
        let transactionsProvider = TransactionsProvider(transactionDataStoreService: transactionDataStoreService)
        
        // @dev init with empty filter
        let txDateFilter = TransactionDateFilter()
        
        let presenter = TransactionsPresenter(transactionsDateFilter: txDateFilter,
                                              transactionsMapper: transactionMapper)
        let interactor = TransactionsInteractor(account: account,
                                                transactionsProvider: transactionsProvider)
        
        let txSB = UIStoryboard(name: "Transactions", bundle: nil)
        let viewController = txSB.instantiateViewController(withIdentifier: "transactionsVC") as! TransactionsViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
