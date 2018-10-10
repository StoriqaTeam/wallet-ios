//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ConnectPhoneModule {
    
    class func create() -> ConnectPhoneModuleInput {
        let router = ConnectPhoneRouter()
        let presenter = ConnectPhonePresenter()
        
        let userStoreService = UserDataStoreService()
        let interactor = ConnectPhoneInteractor(userStoreService: userStoreService)
        
        let storyboard = UIStoryboard(name: "ConnectPhone", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ConnectPhoneVC") as! ConnectPhoneViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
