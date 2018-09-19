//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

struct PopUpApperance {
    let image: UIImage
    let title: String
    let text: String?
    let attributedText: NSAttributedString?
    let actionButtonTitle: String
    let hasCloseButton: Bool
    let actionBlock: (()->())
    let closeBlock: (()->())?
}

class PopUpModule {
    
    class func create(apperance: PopUpApperance) -> PopUpModuleInput {
        let router = PopUpRouter()
        let presenter = PopUpPresenter(viewApperance: apperance)
        let interactor = PopUpInteractor()
        
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
