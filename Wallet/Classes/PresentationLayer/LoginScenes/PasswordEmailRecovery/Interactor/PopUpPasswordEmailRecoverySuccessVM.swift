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
    var apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: "email_sent".localized(),
                                   text: "check_mail_password_recovery".localized(),
                                   actionButtonTitle: "ok".localized(),
                                   hasCloseButton: false)
    
    
    func performAction() {
        delegate?.closePasswordRecovery()
    }
}
