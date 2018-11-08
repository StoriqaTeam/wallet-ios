//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SessionsModule {
    
    class func create(app: Application) -> SessionsModuleInput {
        let router = SessionsRouter(app: app)
        
        let presenter = SessionsPresenter(sessionDateSorter: app.sessionDateSorter)
        
        let interactor = SessionsInteractor(sessionsDataStoreService: app.sessionsDataStoreService)
        
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
