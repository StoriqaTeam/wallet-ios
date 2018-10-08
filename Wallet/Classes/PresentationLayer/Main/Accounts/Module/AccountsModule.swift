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
    
    func getTransactionsFor(account: Account) -> [Transaction]? {
        return fakeTxProvider.transactionsFor(account: account)
    }
    
    func getAllAccounts() -> [Account] {
        return fakeAccProvider.getAllAccounts()
    }
}


class AccountsModule {
    
    class func create(accountWatcher: CurrentAccountWatcherProtocol,
                      tabBar: UITabBarController,
                      user: User) -> AccountsModuleInput {
        let router = AccountsRouter()
        
        // Injections
        let fakeAccountsProvider = FakeAccountProvider()
        let fakeTransactionsProvider = FakeTransactionsProvider()
        let accountLinker = FakeAccountLinker(fakeAccProvider: fakeAccountsProvider, fakeTxProvider: fakeTransactionsProvider)
        let converterFactory = CurrecncyConverterFactory()
        let currencyFormatter = CurrencyFormatter()
        let accountTypeResolver = AccountTypeResolver()
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
