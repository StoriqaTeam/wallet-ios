//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionsModule {
    
    class func create(app: Application, account: Account) -> TransactionsModuleInput {
        let router = TransactionsRouter(app: app)

        // @dev init with empty filter
        let txDateFilter = TransactionDateFilter()
        
        let presenter = TransactionsPresenter(transactionsDateFilter: txDateFilter,
                                              transactionsMapper: app.transactionMapper)
        let interactor = TransactionsInteractor(account: account,
                                                transactionsProvider: app.transactionsProvider)
        
        let txSB = UIStoryboard(name: "Transactions", bundle: nil)
        let viewController = txSB.instantiateViewController(withIdentifier: "transactionsVC") as! TransactionsViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        // MARK: - Channels
        let txsUpdateChannel = app.channelStorage.txsUpadteChannel
        app.transactionsProvider.setTxsUpdaterChannel(txsUpdateChannel)
        interactor.setTxsUpdateChannelInput(txsUpdateChannel)
        
        return presenter
    }
    
}
