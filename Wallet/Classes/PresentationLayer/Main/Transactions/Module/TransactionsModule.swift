//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionsModule {
    
    class func create(transactions: [TransactionDisplayable]) -> TransactionsModuleInput {
        let router = TransactionsRouter()
        let presenter = TransactionsPresenter()
        
        let interactor = TransactionsInteractor(transactions: transactions)
        
        let txSB = UIStoryboard(name: "Transactions", bundle: nil)
        let viewController = txSB.instantiateViewController(withIdentifier: "transactionsVC") as! TransactionsViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
