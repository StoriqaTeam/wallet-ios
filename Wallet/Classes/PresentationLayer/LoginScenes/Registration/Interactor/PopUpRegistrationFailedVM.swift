//
//  PopUpRegistrationFailedVM.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpRegistrationFailedVMDelegate: class {
    func retry()
}

class PopUpRegistrationFailedVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpRegistrationFailedVMDelegate?
    
    init(message: String) {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "generalErrorIcon"),
                                   title: Localization.failureTitle,
                                   text: message,
                                   actionButtonTitle: Localization.tryAgainButton,
                                   hasCloseButton: true)
    }
    
    func performAction() {
        delegate?.retry()
    }
}
