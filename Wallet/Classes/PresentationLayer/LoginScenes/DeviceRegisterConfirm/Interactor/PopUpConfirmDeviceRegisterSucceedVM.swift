//
//  PopUpConfirmDeviceRegisterSucceedVM.swift
//  Wallet
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpConfirmDeviceRegisterSucceedVMDelegate: class {
    func signIn()
}

class PopUpConfirmDeviceRegisterSucceedVM: PopUpViewModelProtocol {
    weak var delegate: PopUpConfirmDeviceRegisterSucceedVMDelegate?
    var apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: Localization.deviceRegisterSuccessTitle,
                                   text: "",
                                   actionButtonTitle: Localization.signInButton,
                                   hasCloseButton: false)
    
    func performAction() {
        delegate?.signIn()
    }
}
