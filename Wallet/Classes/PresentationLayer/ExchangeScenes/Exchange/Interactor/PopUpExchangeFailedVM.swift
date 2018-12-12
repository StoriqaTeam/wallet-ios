//
//  PopUpExchangeFailedVM.swift
//  Wallet
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpExchangeFailedVMDelegate: class {
    func retry()
}

class PopUpExchangeFailedVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpExchangeFailedVMDelegate?
    
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
