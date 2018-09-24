//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class FakeTransactionsProvider: TransactionsProviderProtocol {
    func transactionsFor(account: Account) -> [Transaction] {
        
        return [
            Transaction(currency: .btc,
                        direction: .send,
                        fiatAmount: 100,
                        cryptoAmount: 2,
                        timestamp: Date(),
                        status: .confirmed,
                        opponent: .contact(name: "Satoshi N.")),
            
            Transaction(currency: .eth,
                        direction: .receive,
                        fiatAmount: 420,
                        cryptoAmount: 2,
                        timestamp: Date(),
                        status: .confirmed,
                        opponent: .address(address: "0x013...1f1")),
            
            Transaction(currency: .stq,
                        direction: .send,
                        fiatAmount: 21,
                        cryptoAmount: 210,
                        timestamp: Date(),
                        status: .confirmed,
                        opponent: .address(address: "Vitaly B.")),
            
            Transaction(currency: .btc,
                        direction: .send,
                        fiatAmount: 5200,
                        cryptoAmount: 0.004,
                        timestamp: Date(),
                        status: .confirmed,
                        opponent: .address(address: "mv12ef12...32"))
        ]
    }
}

class FakeAccountLinker: AccountsLinkerProtocol {
    
    private let fakeAccProvider: AccountsProviderProtocol
    private let fakeTxProvider: TransactionsProviderProtocol
    
    init(fakeAccProvider: AccountsProviderProtocol, fakeTxProvider: TransactionsProviderProtocol) {
        self.fakeAccProvider = fakeAccProvider
        self.fakeTxProvider = fakeTxProvider
    }
    
    func getTransactionsFor(account: Account) -> [Transaction]? {
        return fakeTxProvider.transactionsFor(account:account)
    }
    
    func getAllAccounts() -> [Account] {
        return fakeAccProvider.getAllAccounts()
    }
}


class AccountsModule {
    
    class func create(account: Account) -> AccountsModuleInput {
        let router = AccountsRouter()
        let presenter = AccountsPresenter()
        
        let fakeAccountsProvider = FakeAccountProvider()
        let fakeTransactionsProvider = FakeTransactionsProvider()
        let accountLinker = FakeAccountLinker(fakeAccProvider: fakeAccountsProvider, fakeTxProvider: fakeTransactionsProvider)
        let interactor = AccountsInteractor(accountLinker: accountLinker, account: account)
    
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
