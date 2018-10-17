//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SessionsModule {
    
    class func create() -> SessionsModuleInput {
        let router = SessionsRouter()
        let presenter = SessionsPresenter()
        let interactor = SessionsInteractor()
        let viewController = SessionsViewController()

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
