//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class EditProfileModule {
    
    class func create(app: Application) -> EditProfileModuleInput {
        let router = EditProfileRouter(app: app)
        let presenter = EditProfilePresenter()
        
        let interactor = EditProfileInteractor(userDataStore: app.userDataStoreService,
                                               updateUserNetworkProvider: app.updateUserNetworkProvider,
                                               authTokenProvider: app.authTokenProvider,
                                               signHeaderFactory: app.signHeaderFactory)
        
        let storyboard = UIStoryboard(name: "EditProfile", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        // MARK: - Channels
        let userUpdateChannel = app.channelStorage.userUpdateChannel
        interactor.setUserUpdaterChannel(userUpdateChannel)
        
        return presenter
    }
    
}
