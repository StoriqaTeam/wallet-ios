//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinSetupModule {
    
    class func create(app: Application, qiuckLaunchProvider: QuickLaunchProviderProtocol) -> PinSetupModuleInput {
        let router = PinSetupRouter(app: app)
        let presenter = PinSetupPresenter()
        let interactor = PinSetupInteractor(qiuckLaunchProvider: qiuckLaunchProvider)
        
        let storyboard = UIStoryboard(name: "PinSetup", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PinSetupVC") as! PinSetupViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
