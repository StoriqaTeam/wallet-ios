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
        
        let storyboard = UIStoryboard(name: "DeviceRegisterConfirm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DeviceRegisterConfirmVC")
            as! DeviceRegisterConfirmViewController
        
        interactor.output = presenter
        
        presenter.view = viewController
        viewController.output = presenter
        
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
