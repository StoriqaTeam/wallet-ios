//
//  PopUpDeviceRegisterVM.swift
//  Wallet
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpDeviceRegisterVMDelegate: class {
    func deviceRegisterOkButtonPressed()
}

class PopUpDeviceRegisterVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpDeviceRegisterVMDelegate?
    
    init() {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "signConfirm"),
                                   title: Localization.deviceRegisterTitle,
                                   text: Localization.deviceRegisterMessage,
                                   actionButtonTitle: Localization.okButton,
                                   hasCloseButton: true)
    }
    
    func performAction() {
        delegate?.deviceRegisterOkButtonPressed()
    }
}
