//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DepositModule {
    
    class func create(account: Account? = nil) -> DepositModuleInput {
        let router = DepositRouter()
        let presenter = DepositPresenter()
        
        //Injections
        let qrProvider = QRCodeProvider()
        let accProvider = FakeAccountProvider()
        let interactor = DepositInteractor(qrProvider: qrProvider, accountsProvider: accProvider, account: account)
        
        let depositVC = UIStoryboard(name: "Deposit", bundle: nil)
        let viewController = depositVC.instantiateViewController(withIdentifier: "depositVC") as! DepositViewController

        interactor.output = presenter
        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
