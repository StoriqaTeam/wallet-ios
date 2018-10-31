//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit


class BiometryQuickLaunchModule {
    
    class func create(app: Application, qiuckLaunchProvider: QuickLaunchProviderProtocol) -> BiometryQuickLaunchModuleInput {
        let router = BiometryQuickLaunchRouter(app: app)
        let presenter = BiometryQuickLaunchPresenter()
        let interactor = BiometryQuickLaunchInteractor(qiuckLaunchProvider: qiuckLaunchProvider)
        
        let storyboard = UIStoryboard(name: "BiometryQuickLaunch", bundle: nil)
        let controllerId = "BiometryQuickLaunchVC"
        let viewController = storyboard.instantiateViewController(withIdentifier: controllerId) as! BiometryQuickLaunchViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
