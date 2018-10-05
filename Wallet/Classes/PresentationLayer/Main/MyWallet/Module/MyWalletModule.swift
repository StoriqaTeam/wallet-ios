//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class FakeAccountProvider: AccountsProviderProtocol {
    func getAllAccounts() -> [Account] {
        return [Account(type: .stqBlack,
                        cryptoAmount: "145,678,445.71",
                        fiatAmount: "257,204.00 $",
                        holderName: "Mushchinskii Dmitrii",
                        currency: .stq,
                        cryptoAddress: "0x7E0AfbeAb5ac7E13d4646bC10c5547e69b4AdD4E"),
                Account(type: .eth,
                        cryptoAmount: "892.45",
                        fiatAmount: "257,204.00 $",
                        holderName: "Mushchinskii Dmitrii",
                        currency: .eth,
                        cryptoAddress: "0x9Cc539183De54759261Ef0ee9B3Fe91AEB85407F"),
                Account(type: .btc,
                        cryptoAmount: "123.45",
                        fiatAmount: "257,204.00 $",
                        holderName: "Mushchinskii Dmitrii",
                        currency: .btc,
                        cryptoAddress: "1xJBQjtg8YYzgVZ8htvknGiK7tbYAF9KD"),
                Account(type: .stqGold,
                        cryptoAmount: "123.45",
                        fiatAmount: "257,204.00 $",
                        holderName: "Mushchinskii Dmitrii",
                        currency: .stq,
                        cryptoAddress: "1xJBQjtg8YYzgVZ8htvknGiK7tbYAF9KD"),
                Account(type: .stq,
                        cryptoAmount: "123.45",
                        fiatAmount: "257,204.00 $",
                        holderName: "Mushchinskii Dmitrii",
                        currency: .stq,
                        cryptoAddress: "1xJBQjtg8YYzgVZ8htvknGiK7tbYAF9KD")]
    }
}


class MyWalletModule {
    
    class func create(tabBar: UITabBarController, accountWatcher: CurrentAccountWatcherProtocol) -> MyWalletModuleInput {
        let router = MyWalletRouter()
        let presenter = MyWalletPresenter()
        presenter.mainTabBar = tabBar
        
        let fakeAccountsProvider = FakeAccountProvider()
        let interactor = MyWalletInteractor(accountsProvider: fakeAccountsProvider, accountWatcher: accountWatcher)
        
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
