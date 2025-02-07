//
//  PopUpSendConfirmSuccessVM.swift
//  Wallet
//
//  Created by Storiqa on 30/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpSendConfirmSuccessVMDelegate: class {
    func okButtonPressed()
}

class PopUpSendConfirmSuccessVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpSendConfirmSuccessVMDelegate?
    
    init() {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: Localization.sendTransactionTitle,
                                   text: "",
                                   actionButtonTitle: Localization.okButton,
                                   hasCloseButton: false)
    }
    
    func performAction() {
        delegate?.okButtonPressed()
    }
}
