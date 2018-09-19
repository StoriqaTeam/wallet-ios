//
//  PasswordEmailRecoveryPasswordEmailRecoveryRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PasswordEmailRecoveryRouter {

}


// MARK: - PasswordEmailRecoveryRouterInput

extension PasswordEmailRecoveryRouter: PasswordEmailRecoveryRouterInput {
    func showSuccess(from viewController: UIViewController) {
        
        //FIXME: - вынести в модуль popup vc
        //TODO: image, title, text, action
        viewController.presentPopup(image: #imageLiteral(resourceName: "faceid"),
                     title: "email_sent".localized(),
                     text: "TODO: text",
                     actionTitle: "Ok",
                     hasCloseButton: false,
                     actionBlock: {})
    }
    
    func showFailure(message: String, from viewController: UIViewController) {
        
        //FIXME: - вынести в модуль popup vc
        //TODO: image, title
        viewController.presentPopup(image: #imageLiteral(resourceName: "faceid"),
                                    title: "smth_went_wrong".localized(),
                                    text: message,
                                    actionTitle: "try_again".localized(),
                                    hasCloseButton: true,
                                    actionBlock: {})
    }
    
    
}
