//
//  PopUpDeviceRegisterFailedSendEmailVM.swift
//  Wallet
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpDeviceRegisterFailedSendEmailVMDelegate: class {
    func retryDeviceRegister()
}

class PopUpDeviceRegisterFailedSendEmailVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpDeviceRegisterFailedSendEmailVMDelegate?
    
    init(message: String) {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "generalErrorIcon"),
                                   title: Localization.failureTitle,
                                   text: message,
                                   actionButtonTitle: Localization.tryAgainButton,
                                   hasCloseButton: true)
    }
    
    func performAction() {
        delegate?.retryDeviceRegister()
    }
}
