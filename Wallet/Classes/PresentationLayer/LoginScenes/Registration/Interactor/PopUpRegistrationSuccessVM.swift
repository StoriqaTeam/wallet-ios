//
//  PopUpRegistrationSuccessVM.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpRegistrationSuccessVMDelegate: class {
    func okButtonPressed()
}

class PopUpRegistrationSuccessVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpRegistrationSuccessVMDelegate?
    
    init(email: String) {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: "email_sent".localized(),
                                   text: "check_email".localized() + email,
                                   actionButtonTitle: "ok".localized(),
                                   hasCloseButton: false)
    }
    
    func performAction() {
        delegate?.okButtonPressed()
    }
}
