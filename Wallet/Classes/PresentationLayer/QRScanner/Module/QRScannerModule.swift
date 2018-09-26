//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class QRScannerModule {
    
    class func create(sendProvider: SendTransactionBuilderProtocol) -> QRScannerModuleInput {
        let router = QRScannerRouter()
        let presenter = QRScannerPresenter()
        
        //Injections
        let resolver = QRCodeResolver()
        let interactor = QRScannerInteractor(sendProvider: sendProvider,
                                             qrCodeResolver: resolver)
        
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
