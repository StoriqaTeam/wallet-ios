//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PasswordRecoveryConfirmRouter {

}


// MARK: - PasswordRecoveryConfirmRouterInput

extension PasswordRecoveryConfirmRouter: PasswordRecoveryConfirmRouterInput {
    func showSuccess(from viewController: UIViewController) {
        
        //FIXME: - вынести в модуль popup vc
        //TODO: image, title, text
        
        viewController.presentPopup(image: #imageLiteral(resourceName: "faceid"),
                     title: "psw_recovery_result_success_title".localized(),
                     text: "psw_recovery_result_success_subtitle".localized(),
                     actionTitle: "Sign in",
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
