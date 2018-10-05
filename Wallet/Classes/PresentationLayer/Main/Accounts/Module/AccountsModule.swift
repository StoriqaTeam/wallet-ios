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
    
    func getTransactionsFor(account: AccountDisplayable) -> [Transaction]? {
        return fakeTxProvider.transactionsFor(account:account)
    }
    
    func getAllAccounts() -> [AccountDisplayable] {
        return fakeAccProvider.getAllAccounts()
    }
}


class AccountsModule {
    
    class func create(accountWatcher: CurrentAccountWatcherProtocol, tabBar: UITabBarController) -> AccountsModuleInput {
        let router = AccountsRouter()
        let presenter = AccountsPresenter()
        presenter.mainTabBar = tabBar
        
        let fakeAccountsProvider = FakeAccountProvider()
        let fakeTransactionsProvider = FakeTransactionsProvider()
        let accountLinker = FakeAccountLinker(fakeAccProvider: fakeAccountsProvider, fakeTxProvider: fakeTransactionsProvider)
        let interactor = AccountsInteractor(accountLinker: accountLinker, accountWatcher: accountWatcher)
    
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
