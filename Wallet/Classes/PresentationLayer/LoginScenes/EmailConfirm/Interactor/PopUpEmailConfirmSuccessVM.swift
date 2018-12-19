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
                                   title: Localization.emailConfirmTitle,
                                   text: "",
                                   actionButtonTitle: Localization.signInButton,
                                   hasCloseButton: false)
    }
    
    func performAction() {
        delegate?.signInButtonPressed()
    }
}
