//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DeviceRegisterConfirmModule {
    
    class func create(app: Application, token: String) -> DeviceRegisterConfirmModuleInput {
        let router = DeviceRegisterConfirmRouter(app: app)
        let presenter = DeviceRegisterConfirmPresenter()
        let interactor = DeviceRegisterConfirmInteractor(
            token: token,
            confirmAddDeviceNetworkProvider: app.confirmAddDeviceNetworkProvider)
        
        let viewController = DeviceRegisterConfirmViewController()
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
