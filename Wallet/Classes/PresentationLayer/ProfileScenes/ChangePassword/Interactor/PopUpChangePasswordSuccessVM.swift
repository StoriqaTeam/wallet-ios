//
//  PopUpChangePasswordSuccessVM.swift
//  Wallet
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpChangePasswordSuccessVMDelegate: class {
    func okButtonPressed()
}

class PopUpChangePasswordSuccessVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpChangePasswordSuccessVMDelegate?
    
    init() {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: Localization.changePasswordTitle,
                                   text: "",
                                   actionButtonTitle: Localization.okButton,
                                   hasCloseButton: false)
    }
    
    func performAction() {
        delegate?.okButtonPressed()
    }
}
