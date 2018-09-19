//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordInputModule {
    
    class func create() -> PasswordInputModuleInput {
        let router = PasswordInputRouter()
        let presenter = PasswordInputPresenter()
        
        // Injection
        let keychainProvider = KeychainProvider()
        let pinValidator = PinValidationProvider(keychainProvider: keychainProvider)
        let interactor = PasswordInputInteractor(pinValidator: pinValidator)
        
        let passwordInputSb = UIStoryboard(name: "PasswordInput", bundle: nil)
        let viewController = passwordInputSb.instantiateViewController(withIdentifier: "PinLoginVC") as! PasswordInputViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
