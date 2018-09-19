//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordEmailRecoveryModule {
    
    class func create() -> PasswordEmailRecoveryModuleInput {
        let router = PasswordEmailRecoveryRouter()
        let presenter = PasswordEmailRecoveryPresenter()
        
        //Injection
        let validator = PasswordEmailRecoveryFormValidator()
        let interactor = PasswordEmailRecoveryInteractor(formValidator: validator)
        
        let storyboard = UIStoryboard(name: "PasswordEmailRecovery", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PasswordRecoveryVC") as! PasswordEmailRecoveryViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
