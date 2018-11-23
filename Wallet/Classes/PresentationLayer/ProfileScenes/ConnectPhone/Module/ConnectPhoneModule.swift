//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ConnectPhoneModule {
    
    class func create(app: Application) -> ConnectPhoneModuleInput {
        let router = ConnectPhoneRouter(app: app)
        let presenter = ConnectPhonePresenter()
        
        let interactor = ConnectPhoneInteractor(userDataStore: app.userDataStoreService,
                                                updateUserNetworkProvider: app.updateUserNetworkProvider,
                                                authTokenProvider: app.authTokenProvider,
                                                signHeaderFactory: app.signHeaderFactory)
        
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
