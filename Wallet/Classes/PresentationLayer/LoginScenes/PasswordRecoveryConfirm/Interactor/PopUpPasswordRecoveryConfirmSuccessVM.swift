//
//  PopUpPasswordRecoveryConfirmSuccessVM.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpPasswordRecoveryConfirmSuccessVMDelegate: class {
    func signIn()
}

class PopUpPasswordRecoveryConfirmSuccessVM: PopUpViewModelProtocol {
    weak var delegate: PopUpPasswordRecoveryConfirmSuccessVMDelegate?
    var apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: Localization.passwordRecoveryConfirmTitle,
                                   text: Localization.passwordRecoveryConfirmMessage,
                                   actionButtonTitle: Localization.signInButton,
                                   hasCloseButton: false)
    
    func performAction() {
        delegate?.signIn()
    }
    
}
