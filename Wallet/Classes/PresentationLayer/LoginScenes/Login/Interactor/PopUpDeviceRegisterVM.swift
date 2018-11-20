//
//  PopUpDeviceRegisterVM.swift
//  Wallet
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpDeviceRegisterVMDelegate: class {
    func okButtonPressed()
}

class PopUpDeviceRegisterVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpDeviceRegisterVMDelegate?
    
    init() {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "generalErrorIcon"),
                                   title: "Your device is not registered yet",
                                   text: "Do you want to register this device to your account?",
                                   actionButtonTitle: "ok".localized(),
                                   hasCloseButton: true)
    }
    
    func performAction() {
        delegate?.okButtonPressed()
    }
}
