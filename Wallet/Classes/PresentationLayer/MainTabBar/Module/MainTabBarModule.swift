//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MainTabBarModule {
    
    class func create(app: Application) -> MainTabBarModuleInput {
        let router = MainTabBarRouter(app: app)
        let presenter = MainTabBarPresenter()
        
        let accountWatcher = app.accountWatcherFactory.create()
        let shortPollingTimer = app.shortPollingTimerFactory.createShortPollingTimer(timeout: 40)
        let interactor = MainTabBarInteractor(accountWatcher: accountWatcher,
                                              userDataStoreService: app.userDataStoreService,
                                              accountsUpdater: app.accountsUpdater,
                                              txsUpdater: app.transactionsUpdater,
                                              ratesUpdater: app.ratesUpdater,
                                              shortPollingTimer: shortPollingTimer,
                                              app: app)
        
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "mainTabBarVC") as! MainTabBarViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        
        // MARK: Channels output
        
        let shortPollingChannel = app.channelStorage.shortPollingChannel
        shortPollingTimer.setOutputChannel(shortPollingChannel)
        shortPollingTimer.startPolling()
        

        // MARK: - Channels input
        
        let depositShortPollingChannel = app.channelStorage.depositShortPollingChannel
        let tokenExpiredChannel = app.channelStorage.tokenExpiredChannel
        
        interactor.setShortPollingChannelInput(shortPollingChannel)
        interactor.setDepositShortPollingChannelInput(depositShortPollingChannel)
        interactor.setTokenExpiredChannelInput(tokenExpiredChannel)
        
        return presenter
    }
    
}
