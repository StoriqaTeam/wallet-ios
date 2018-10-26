//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import FacebookLogin


class RegistrationModule {
    
    class func create() -> RegistrationModuleInput {
        let router = RegistrationRouter()
        let presenter = RegistrationPresenter()
        
        //Injection
        let socialVM = SocialNetworkAuthViewModel(facebookLoginManager: LoginManager())
        let validationProvider = RegistrationFormValidatonProvider()
        let registrationNetworkProvider = RegistrationNetworkProvider()
        let interactor = RegistrationInteractor(socialViewVM: socialVM,
                                                formValidationProvider: validationProvider,
                                                registrationNetworkProvider: registrationNetworkProvider)
        
        let registrationSb = UIStoryboard(name: "Registration", bundle: nil)
        let viewController = registrationSb.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationViewController
        
        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}