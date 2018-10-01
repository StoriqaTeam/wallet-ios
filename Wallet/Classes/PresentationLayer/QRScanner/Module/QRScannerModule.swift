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
        let btcValidator = BitcoinAddressValidator(network: .btcMainnet)
        let ethValidator = EthereumAddressValidator()
        let addressResolver = CryptoAddressResolver(btcAddressValidator: btcValidator,
                                                    ethAddressValidator: ethValidator)
        
        let interactor = QRScannerInteractor(sendProvider: sendProvider,
                                             addressResolver: addressResolver)
        
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
