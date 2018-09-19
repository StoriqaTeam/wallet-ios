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
        
        //TODO: image, title, text, action
        
        let popUpApperance = PopUpApperance(image: #imageLiteral(resourceName: "faceid"),
                                            title: "email_sent".localized(),
                                            text: "TODO: text",
                                            attributedText: nil,
                                            actionButtonTitle: "Ok",
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
