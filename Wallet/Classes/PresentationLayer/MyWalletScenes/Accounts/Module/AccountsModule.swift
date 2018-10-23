//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class FakeAccountLinker: AccountsLinkerProtocol {
    
    private let fakeAccProvider: AccountsProviderProtocol
    private let fakeTxProvider: TransactionsProviderProtocol
    
    init(fakeAccProvider: AccountsProviderProtocol, fakeTxProvider: TransactionsProviderProtocol) {
        self.fakeAccProvider = fakeAccProvider
        self.fakeTxProvider = fakeTxProvider
    }
    
    func getTransactionsFor(account: Account) -> [TransactionDisplayable]? {
        return fakeTxProvider.transactionsFor(account: account)
    }
    
    func getAllAccounts() -> [Account] {
        return fakeAccProvider.getAllAccounts()
    }
    
    func setObserver(_ observer: AccountsProviderDelegate) {
        fakeAccProvider.setObserver(observer)
    }
    
}


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
        let contactsProvider = FakeContactsProvider()
        let contactsMapper = ContactsMapper()
        let transactionOpponentResolver = TransactionOpponentResolver(contactsProvider: contactsProvider,
                                                                      transactionDirectionResolver: transactionDirectionResolver,
                                                                      contactsMapper: contactsMapper)
        
        let transactionMapper = TransactionMapper(currencyFormatter: currencyFormatter,
                                                  converterFactory: converterFactory,
                                                  transactionDirectionResolver: transactionDirectionResolver,
                                                  transactionOpponentResolver: transactionOpponentResolver)
        
        let transactionsProvider = FakeTransactionsProvider(transactionMapper: transactionMapper)
        let accountLinker = FakeAccountLinker(fakeAccProvider: accountsProvider, fakeTxProvider: transactionsProvider)
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: currencyFormatter,
                                                converterFactory: converterFactory,
                                                accountTypeResolver: accountTypeResolver)
        
        let presenter = AccountsPresenter(accountDisplayer: accountDisplayer)
        presenter.mainTabBar = tabBar
        let interactor = AccountsInteractor(accountLinker: accountLinker,
                                            accountWatcher: accountWatcher)
    
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
