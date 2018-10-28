//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class QRScannerModule {
    
    class func create(app: Application, sendTransactionBuilder: SendProviderBuilderProtocol) -> QRScannerModuleInput {
        let router = QRScannerRouter(app: app)
        let presenter = QRScannerPresenter()
        
        let interactor = QRScannerInteractor(sendTransactionBuilder: sendTransactionBuilder,
                                             addressResolver: app.cryptoAddressResolver)
        
        let loginSb = UIStoryboard(name: "QRScanner", bundle: nil)
        let viewController = loginSb.instantiateViewController(withIdentifier: "QRScannerVC") as! QRScannerViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
