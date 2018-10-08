//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MainTabBarModule {
    
    class func create() -> MainTabBarModuleInput {
        let router = MainTabBarRouter()
        let presenter = MainTabBarPresenter()
        
        let accountsProvider = FakeAccountProvider()
        let accountWatcher = CurrentAccountWatcher(accountProvider: accountsProvider)
        let userDataStoreService = FakeUserDataStoreService()
        
        let interactor = MainTabBarInteractor(accountWatcher: accountWatcher,
                                              userDataStoreService: userDataStoreService)
        
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "mainTabBarVC") as! MainTabBarViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
