//
//  PopUpResendConfirmEmailVM.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpResendConfirmEmailVMDelegate: class {
    func resendButtonPressed()
}

class PopUpResendConfirmEmailVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpResendConfirmEmailVMDelegate?
    
    init() {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "linkErrorIcon"),
                                   title: Localization.resendConfirmEmailTitle,
                                   text: Localization.resendConfirmEmailMessage,
                                   actionButtonTitle: Localization.resendButton,
                                   hasCloseButton: true)
    }
    
    func performAction() {
        delegate?.resendButtonPressed()
    }
}
