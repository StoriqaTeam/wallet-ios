//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

struct QuickLaunchScreenApperance {
    let title: String
    let subtitle: String?
    let image: UIImage
    let actionButtonTitle: String
    let actionBlock: (()->())
    let cancelBlock: (()->())
}

struct AuthData {
    let email: String
    let password: String
}

class QuickLaunchModule {
    
    class func create(authData: AuthData, screenApperance: QuickLaunchScreenApperance) -> QuickLaunchModuleInput {
        let router = QuickLaunchRouter()
        let presenter = QuickLaunchPresenter(screenApperance: screenApperance)
        
        //Injections
        let keychainProvider = KeychainProvider()
        let biometricAuthProvider = BiometricAuthProvider(errorParser: BiometricAuthErrorParser())
        let provider = QuickLaunchProvider(authData: authData, keychainProvider: keychainProvider, biometricAuthProvider: biometricAuthProvider)
        let interactor = QuickLaunchInteractor(qiuckLaunchProvider: provider)
        
        let storyboard = UIStoryboard(name: "QuickLaunch", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "QuickLaunchVC") as! QuickLaunchViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
