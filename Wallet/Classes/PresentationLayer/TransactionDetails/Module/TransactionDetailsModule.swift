//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionDetailsModule {
    
    class func create(transaction: Transaction) -> TransactionDetailsModuleInput {
        let router = TransactionDetailsRouter()
        let presenter = TransactionDetailsPresenter()
        let interactor = TransactionDetailsInteractor(transaction: transaction)
        
        let transactionsDetailsSB = UIStoryboard(name: "TransactionDetails", bundle: nil)
        let viewController = transactionsDetailsSB.instantiateViewController(withIdentifier: "transactionDetailsVC")
        let txDetailsViewController = viewController as! TransactionDetailsViewController

        interactor.output = presenter

        txDetailsViewController.output = presenter

        presenter.view = txDetailsViewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
