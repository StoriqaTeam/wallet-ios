//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordRecoveryConfirmModule {
    
    class func create(app: Application, token: String) -> PasswordRecoveryConfirmModuleInput {
        let router = PasswordRecoveryConfirmRouter(app: app)
        let presenter = PasswordRecoveryConfirmPresenter()
        
        let interactor = PasswordRecoveryConfirmInteractor(token: token,
                                                           formValidator: app.passwordRecoveryConfirmFormValidator,
                                                           networkProvider: app.confirmResetPasswordNetworkProvider)
        
        let storyboard = UIStoryboard(name: "PasswordRecoveryConfirm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PasswordRecoveryConfirmVC")
            as! PasswordRecoveryConfirmViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
