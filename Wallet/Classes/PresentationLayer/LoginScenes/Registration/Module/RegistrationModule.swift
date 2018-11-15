//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import FacebookLogin


class RegistrationModule {
    
    class func create(app: Application) -> RegistrationModuleInput {
        let router = RegistrationRouter(app: app)
        let presenter = RegistrationPresenter()
        
        let socialVM = SocialNetworkAuthViewModel(facebookLoginManager: app.facebookLoginManager)
        let biometricAuthProvider = app.biometricAuthProviderFactory.create()
        
        let interactor = RegistrationInteractor(socialViewVM: socialVM,
                                                formValidationProvider: app.registrationFormValidatonProvider,
                                                registrationNetworkProvider: app.registrationNetworkProvider,
                                                loginService: app.loginService,
                                                biometricAuthProvider: biometricAuthProvider)
        
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
