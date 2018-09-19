//
//  RegistrationRegistrationRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class RegistrationRouter {

}


// MARK: - RegistrationRouterInput

extension RegistrationRouter: RegistrationRouterInput {
    
    func showLogin() {
        LoginModule.create().present()
    }
    
    func showSuccess(email: String, from viewController: UIViewController) {
        //TODO: image, action
        
        let popUpApperance = PopUpApperance(image: #imageLiteral(resourceName: "faceid"),
                                            title: "email_sent".localized(),
                                            text: "check_email".localized() + email,
                                            attributedText: nil,
                                            actionButtonTitle: "sign_in".localized(),
                                            hasCloseButton: false,
                                            actionBlock: {},
                                            closeBlock: nil)
        PopUpModule.create(apperance: popUpApperance).present(from: viewController)
    }
    
    func showFailure(message: String, from viewController: UIViewController) {
        //TODO: image, action
        
        let popUpApperance = PopUpApperance(image: #imageLiteral(resourceName: "faceid"),
                                            title: "smth_went_wrong".localized(),
                                            text: message,
                                            attributedText: nil,
                                            actionButtonTitle: "try_again".localized(),
                                            hasCloseButton: true,
                                            actionBlock: {},
                                            closeBlock: {})
        PopUpModule.create(apperance: popUpApperance).present(from: viewController)
    }
    
}
