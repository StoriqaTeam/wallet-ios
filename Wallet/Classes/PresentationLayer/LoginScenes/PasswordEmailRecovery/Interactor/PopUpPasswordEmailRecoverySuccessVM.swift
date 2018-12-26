//
//  PopUpPasswordEmailRecoverySuccessVM.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpPasswordEmailRecoverySuccessVMDelegate: class {
    func closePasswordRecovery()
}

class PopUpPasswordEmailRecoverySuccessVM: PopUpViewModelProtocol {
    weak var delegate: PopUpPasswordEmailRecoverySuccessVMDelegate?
    var apperance = PopUpApperance(image: #imageLiteral(resourceName: "mailIcon"),
                                   title: Localization.emailSentTitle,
                                   text: Localization.passwordEmailRecoveryMessage,
                                   actionButtonTitle: Localization.okButton,
                                   hasCloseButton: false)
    
    
    func performAction() {
        delegate?.closePasswordRecovery()
    }
}
