//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordEmailRecoveryModule {
    
    class func create(app: Application) -> PasswordEmailRecoveryModuleInput {
        let router = PasswordEmailRecoveryRouter(app: app)
        let presenter = PasswordEmailRecoveryPresenter()
        let interactor = PasswordEmailRecoveryInteractor(networkProvider: app.resetPasswordNetworkProvider)
        
        let storyboard = UIStoryboard(name: "PasswordEmailRecovery", bundle: nil)
        let controllerId = "PasswordRecoveryVC"
        let viewController = storyboard.instantiateViewController(withIdentifier: controllerId) as! PasswordEmailRecoveryViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
