//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class EditProfileModule {
    
    class func create() -> EditProfileModuleInput {
        let router = EditProfileRouter()
        let presenter = EditProfilePresenter()
        
        let userDataStore = UserDataStoreService()
        let interactor = EditProfileInteractor(userDataStore: userDataStore)
        
        let storyboard = UIStoryboard(name: "EditProfile", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
