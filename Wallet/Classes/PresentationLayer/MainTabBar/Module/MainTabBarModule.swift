//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MainTabBarModule {
    
    class func create(app: Application) -> MainTabBarModuleInput {
        let router = MainTabBarRouter(app: app)
        let presenter = MainTabBarPresenter()
        
        let interactor = MainTabBarInteractor(accountWatcher: app.accountWatcher,
                                              userDataStoreService: app.userDataStoreService,
                                              accountsUpdater: app.accountsUpdater,
                                              txsUpdater: app.transactionsUpdater,
                                              ratesUpdater: app.ratesUpdater,
                                              app: app)
        
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "mainTabBarVC") as! MainTabBarViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        // MARK: - Channels
        let shortPollingChannel = app.channelStorage.shortPollingChannel
        interactor.setShortPollingChannelInput(shortPollingChannel)
        
        return presenter
    }
    
}
