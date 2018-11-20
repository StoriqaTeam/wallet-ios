//
//  PopUpConfirmDeviceRegisterSucceedVM.swift
//  Wallet
//
//  Created by Tata Gri on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpConfirmDeviceRegisterSucceedVMDelegate: class {
    func signIn()
}

class PopUpConfirmDeviceRegisterSucceedVM: PopUpViewModelProtocol {
    weak var delegate: PopUpConfirmDeviceRegisterSucceedVMDelegate?
    var apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: "Device was successfully registered",
                                   text: "",
                                   actionButtonTitle: "sign_in".localized(),
                                   hasCloseButton: false)
    
    func performAction() {
        delegate?.signIn()
    }
}
