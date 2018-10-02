//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class FakeAccountProvider: AccountsProviderProtocol {
    func getAllAccounts() -> [Account] {
        return [Account(type: .stqBlack, cryptoAmount: "145,678,445.71", fiatAmount: "257,204.00 $", holderName: "Mushchinskii Dmitrii", currency: .stq),
                Account(type: .eth, cryptoAmount: "892.45", fiatAmount: "257,204.00 $", holderName: "Mushchinskii Dmitrii", currency: .eth),
                Account(type: .btc, cryptoAmount: "123.45", fiatAmount: "257,204.00 $", holderName: "Mushchinskii Dmitrii", currency: .btc)]
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
