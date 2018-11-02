//
//  PopUpEmailConfirmSuccessVM.swift
//  Wallet
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpEmailConfirmSuccessVMDelegate: class {
    func signInButtonPressed()
}

class PopUpEmailConfirmSuccessVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpEmailConfirmSuccessVMDelegate?
    
    init() {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: "Email was successfully confirmed",
                                   text: "",
                                   actionButtonTitle: "sign_in".localized(),
                                   hasCloseButton: false)
    }
    
    func performAction() {
        delegate?.signInButtonPressed()
    }
}
