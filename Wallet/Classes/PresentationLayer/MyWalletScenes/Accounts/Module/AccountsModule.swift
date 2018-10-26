//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class AccountsModule {
    
    class func create(accountWatcher: CurrentAccountWatcherProtocol,
                      tabBar: UITabBarController,
                      user: User) -> AccountsModuleInput {
        let router = AccountsRouter()
        
        // Injections
        let dataStoreService = AccountsDataStore()
        let accountsProvider = AccountsProvider(dataStoreService: dataStoreService)
        let converterFactory = CurrecncyConverterFactory()
        let currencyFormatter = CurrencyFormatter()
        let accountTypeResolver = AccountTypeResolver()
        let transactionDirectionResolver = TransactionDirectionResolver(accountsProvider: accountsProvider)
        let contactsDataStoreService = ContactsDataStoreService()
        let contactsProvider = ContactsProvider(dataStoreService: contactsDataStoreService)
        let contactsMapper = ContactsMapper()
        let transactionOpponentResolver = TransactionOpponentResolver(contactsProvider: contactsProvider,
                                                                      transactionDirectionResolver: transactionDirectionResolver,
                                                                      contactsMapper: contactsMapper)
        
        let transactionMapper = TransactionMapper(currencyFormatter: currencyFormatter,
                                                  converterFactory: converterFactory,
                                                  transactionDirectionResolver: transactionDirectionResolver,
                                                  transactionOpponentResolver: transactionOpponentResolver)
        let transactionDataStoreService = TransactionDataStoreService()
        
        let transactionsProvider = TransactionsProvider(transactionDataStoreService: transactionDataStoreService)
        let accountLinker = AccountsLinker(accountsProvider: accountsProvider, transactionsProvider: transactionsProvider)
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: currencyFormatter,
                                                converterFactory: converterFactory,
                                                accountTypeResolver: accountTypeResolver)
        let presenter = AccountsPresenter(accountDisplayer: accountDisplayer,
                                          transactionsMapper: transactionMapper)
        presenter.mainTabBar = tabBar
        let interactor = AccountsInteractor(accountLinker: accountLinker,
                                            accountWatcher: accountWatcher,
                                            transactionsProvider: transactionsProvider)
    
        let accountsVC = UIStoryboard(name: "Accounts", bundle: nil)
        let viewController = accountsVC.instantiateViewController(withIdentifier: "accountsVC") as! AccountsViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
