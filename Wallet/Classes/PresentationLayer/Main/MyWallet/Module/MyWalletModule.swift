//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class FakeAccountProvider: AccountsProviderProtocol {

    func getAllAccounts() -> [Account] {
        return [Account(id: "4",
                        balance: 4123.45,
                        currency: .stq,
                        userId: "0",
                        accountAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                        name: "STQ Black account"),
                Account(id: "2",
                        balance: 892.45,
                        currency: .eth,
                        userId: "0",
                        accountAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                        name: "ETH account"),
                Account(id: "3",
                        balance: 123.45,
                        currency: .btc,
                        userId: "0",
                        accountAddress: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2",
                        name: "BTC account")
        ]
    }
    
    func getEthereumAddress() -> String {
        let allAccounts = getAllAccounts()
        return allAccounts.first(where: { $0.currency == .eth })!.accountAddress
    }
    
    func getBitcoinAddress() -> String {
        let allAccounts = getAllAccounts()
        return allAccounts.first(where: { $0.currency == .btc })!.accountAddress
    }
    
}


class MyWalletModule {
    
    class func create(tabBar: UITabBarController,
                      accountWatcher: CurrentAccountWatcherProtocol,
                      user: User) -> MyWalletModuleInput {
        let router = MyWalletRouter()
        
        // Injections
        let converterFactory = CurrecncyConverterFactory()
        let currencyFormatter = CurrencyFormatter()
        let fakeAccountsProvider = FakeAccountProvider()
        let accountTypeResolver = AccountTypeResolver()
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: currencyFormatter,
                                                converterFactory: converterFactory,
                                                accountTypeResolver: accountTypeResolver)
        
        let presenter = MyWalletPresenter(user: user,
                                          accountDisplayer: accountDisplayer)
        presenter.mainTabBar = tabBar
        let interactor = MyWalletInteractor(accountsProvider: fakeAccountsProvider,
                                            accountWatcher: accountWatcher)
        
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
