//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinInputModule {
    
    class func create(app: Application) -> PinInputModuleInput {
        let router = PinInputRouter(app: app)
        let presenter = PinInputPresenter()
        
        let interactor = PinInputInteractor(defaultsProvider: app.defaultsProvider,
                                            pinValidator: app.pinValidationProvider,
                                            biometricAuthProvider: app.biometricAuthProvider,
                                            userStoreService: app.userDataStoreService)
        
        let pinInputSb = UIStoryboard(name: "PinInput", bundle: nil)
        let viewController = pinInputSb.instantiateViewController(withIdentifier: "PinLoginVC") as! PinInputViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
