//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DepositModule {
    
    class func create(app: Application,
                      accountWatcher: CurrentAccountWatcherProtocol) -> DepositModuleInput {
        
        let router = DepositRouter(app: app)
        let depositShortPollintTimer = app.shortPollingTimerFactory.createDepositShortPollingTimer(timeout: 7)
        
        let presenter = DepositPresenter(accountDisplayer: app.accountDisplayer,
                                         depositShortPollingTimer: depositShortPollintTimer)
        let interactor = DepositInteractor(qrProvider: app.qrCodeProvider,
                                           accountsProvider: app.accountsProvider,
                                           accountWatcher: accountWatcher)
        
        let depositVC = UIStoryboard(name: "Deposit", bundle: nil)
        let viewController = depositVC.instantiateViewController(withIdentifier: "depositVC") as! DepositViewController

        interactor.output = presenter
        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        
        // MARK: - Channels
        let accountsUpadteChannel = app.channelStorage.accountsUpadteChannel
        let depositShortPollingChannel = app.channelStorage.depositShortPollingChannel
        
        app.accountsProvider.setAccountsUpdaterChannel(accountsUpadteChannel)
        interactor.setAccountsUpdateChannelInput(accountsUpadteChannel)
        depositShortPollintTimer.setOutputChannel(depositShortPollingChannel)
        
        return presenter
    }
    
}
