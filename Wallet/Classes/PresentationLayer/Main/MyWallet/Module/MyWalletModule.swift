//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class FakeAccountProvider: AccountsProviderProtocol {
    func getAllAccounts() -> [Account] {
        return [Account(id: "1",
                        balance: 1456784.71,
                        currency: .stq,
                        userId: "0",
                        accountAddress: "0x7E0AfbeAb5ac7E13d4646bC10c5547e69b4AdD4E",
                        name: "STQ Gold account"),
                Account(id: "2",
                        balance: 892.45,
                        currency: .eth,
                        userId: "0",
                        accountAddress: "0x9Cc539183De54759261Ef0ee9B3Fe91AEB85407F",
                        name: "ETH account"),
                Account(id: "3",
                        balance: 123.45,
                        currency: .btc,
                        userId: "0",
                        accountAddress: "1xJBQjtg8YYzgVZ8htvknGiK7tbYAF9KD",
                        name: "BTC account"),
                Account(id: "4",
                        balance: 4123.45,
                        currency: .stq,
                        userId: "0",
                        accountAddress: "0x7E0AfbeAb5ac7E13d4646bC10c5547e69b4AdD4E",
                        name: "STQ Black account"),
                Account(id: "5",
                        balance: 123.45,
                        currency: .stq,
                        userId: "0",
                        accountAddress: "0x7E0AfbeAb5ac7E13d4646bC10c5547e69b4AdD4E",
                        name: "STQ account")
        ]
    }
}


class MyWalletModule {
    
    class func create(tabBar: UITabBarController, accountWatcher: CurrentAccountWatcherProtocol) -> MyWalletModuleInput {
        let router = MyWalletRouter()
        let presenter = MyWalletPresenter()
        presenter.mainTabBar = tabBar
        
        // Injections
        let converterFactory = CurrecncyConverterFactory()
        let userDataStoreService = FakeUserDataStoreService()
        let formatter = CurrencyFormatter()
        let fakeAccountsProvider = FakeAccountProvider()
        let accountDisplayer = AccountDisplayer(currencyFormatter: formatter,
                                                converterFactory: converterFactory,
                                                userDataStoreService: userDataStoreService)
        let interactor = MyWalletInteractor(accountsProvider: fakeAccountsProvider,
                                            accountWatcher: accountWatcher,
                                            accountDisplayer: accountDisplayer)
        
        let myWalletSb = UIStoryboard(name: "MyWallet", bundle: nil)
        let viewController = myWalletSb.instantiateViewController(withIdentifier: "myWalletVC") as! MyWalletViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
