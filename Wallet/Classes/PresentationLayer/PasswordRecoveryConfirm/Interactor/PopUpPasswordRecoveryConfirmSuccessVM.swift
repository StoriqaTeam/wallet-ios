//
//  PopUpPasswordRecoveryConfirmSuccessVM.swift
//  Wallet
//
//  Created by user on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpPasswordRecoveryConfirmSuccessVMDelegate: class {
    func signIn()
}

class PopUpPasswordRecoveryConfirmSuccessVM: PopUpViewModelProtocol {
    weak var delegate: PopUpPasswordRecoveryConfirmSuccessVMDelegate?
    //TODO: image, title, text, action
    var apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: "psw_recovery_result_success_title".localized(),
                                   text: "psw_recovery_result_success_subtitle".localized(),
                                   attributedText: nil,
                                   actionButtonTitle: "sign_in".localized(),
                                   hasCloseButton: false)
    
    func performAction() {
        delegate?.signIn()
    }
    
}
