//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SettingsModule {
    
    class func create(app: Application) -> SettingsModuleInput {
        let router = SettingsRouter(app: app)
        let presenter = SettingsPresenter()
        
        let interactor = SettingsInteractor(defaults: app.defaultsProvider,
                                            keychain: app.keychainProvider,
                                            userStoreService: app.userDataStoreService)
        
        let settingsSb = UIStoryboard(name: "Settings", bundle: nil)
        let viewController = settingsSb.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
