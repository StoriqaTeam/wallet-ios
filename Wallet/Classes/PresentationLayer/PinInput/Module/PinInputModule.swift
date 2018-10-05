//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinInputModule {
    
    class func create() -> PinInputModuleInput {
        let router = PinInputRouter()
        let presenter = PinInputPresenter()
        
        // Injection
        let keychainProvider = KeychainProvider()
        let defaultsProvider = DefaultsProvider()
        let biometricAuthProvider = BiometricAuthProvider(errorParser: BiometricAuthErrorParser())
        let pinValidator = PinValidationProvider(keychainProvider: keychainProvider)
        let interactor = PinInputInteractor(defaultsProvider: defaultsProvider,
                                            pinValidator: pinValidator,
                                            biometricAuthProvider: biometricAuthProvider)
        
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
