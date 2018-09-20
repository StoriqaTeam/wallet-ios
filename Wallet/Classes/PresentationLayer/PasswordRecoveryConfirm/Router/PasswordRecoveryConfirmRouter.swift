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

        //TODO: image, title, text, action
        
        let popUpApperance = PopUpApperance(image: #imageLiteral(resourceName: "faceid"),
                                            title: "psw_recovery_result_success_title".localized(),
                                            text: "psw_recovery_result_success_subtitle".localized(),
                                            attributedText: nil,
                                            actionButtonTitle: "sign_in".localized(),
                                            hasCloseButton: false,
                                            actionBlock: {},
                                            closeBlock: nil)
        PopUpModule.create(apperance: popUpApperance).present(from: viewController)
    }
    
    func showFailure(message: String, from viewController: UIViewController) {
    
        //TODO: image, title, action
        
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
