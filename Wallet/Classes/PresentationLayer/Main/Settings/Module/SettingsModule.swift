//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SettingsModule {
    
    class func create() -> SettingsModuleInput {
        let router = SettingsRouter()
        let presenter = SettingsPresenter()
        
        let defaultProvider = DefaultsProvider()
        let keychainProvider = KeychainProvider()
        let interactor = SettingsInteractor(defaults: defaultProvider, keychain: keychainProvider)
        
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
