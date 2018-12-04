//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionDetailsModule {
    
    class func create(app: Application, transaction: TransactionDisplayable) -> TransactionDetailsModuleInput {
        let router = TransactionDetailsRouter(app: app)
        let presenter = TransactionDetailsPresenter(blockchainExplorerLinkGenerator: app.blockchainExplorerLinkGenerator)
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
