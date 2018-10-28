//
//  Created by Storiqa on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import UIKit


class TransactionFilterModule {
    
    class func create(app: Application, transactionDateFilter: TransactionDateFilterProtocol) -> TransactionFilterModuleInput {
        let router = TransactionFilterRouter(app: app)
        let presenter = TransactionFilterPresenter(transactionDateFilter: transactionDateFilter)
        let interactor = TransactionFilterInteractor()
        let transactionFilterSB = UIStoryboard(name: "TransactionFilter", bundle: nil)
        let viewController = transactionFilterSB.instantiateViewController(withIdentifier: "transactionFilterVC") as! TransactionFilterViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
