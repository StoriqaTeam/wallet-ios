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
    let closeButtonTitle: String?
    
    init(image: UIImage,
         title: String,
         text: String? = nil,
         attributedText: NSAttributedString? = nil,
         actionButtonTitle: String,
         hasCloseButton: Bool,
         closeButtonTitle: String? = nil) {
        self.image = image
        self.title = title
        self.text = text
        self.attributedText = attributedText
        self.actionButtonTitle = actionButtonTitle
        self.hasCloseButton = hasCloseButton
        self.closeButtonTitle = closeButtonTitle ?? "cancel".localized()
    }
}

class PopUpModule {
    
    class func create(viewModel: PopUpViewModelProtocol) -> PopUpModuleInput {
        let router = PopUpRouter()
        let presenter = PopUpPresenter()
        let interactor = PopUpInteractor(viewModel: viewModel)
        
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
