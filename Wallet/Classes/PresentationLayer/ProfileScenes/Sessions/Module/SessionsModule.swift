//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SessionsModule {
    
    class func create() -> SessionsModuleInput {
        let router = SessionsRouter()
        
        let sessionDateSorter = SessionDateSorter()
        let presenter = SessionsPresenter(sessionDateSorter: sessionDateSorter)
        
        let sessionsDataStoreService = SessionsDataStoreService()
        let interactor = SessionsInteractor(sessionsDataStoreService: sessionsDataStoreService)
        
        let sessionsSb = UIStoryboard(name: "Sessions", bundle: nil)
        let viewController = sessionsSb.instantiateViewController(withIdentifier: "sessionsVC") as! SessionsViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
