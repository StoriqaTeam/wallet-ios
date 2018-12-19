//
//  PopUpEmailConfirmFailedVM.swift
//  Wallet
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpEmailConfirmFailedVMDelegate: class {
    func retryButtonPressed()
    func cancelButtonPressed()
}

class PopUpEmailConfirmFailedVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpEmailConfirmFailedVMDelegate?
    
    init(message: String) {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "generalErrorIcon"),
                                   title: Localization.failureTitle,
                                   text: message,
                                   actionButtonTitle: Localization.tryAgainButton,
                                   hasCloseButton: true)
    }
    
    func performAction() {
        delegate?.retryButtonPressed()
    }
    
    func cancelAction() {
        delegate?.cancelButtonPressed()
    }
}
