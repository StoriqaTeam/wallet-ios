//
//  PopUpPasswordEmailRecoveryFailedVM.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpPasswordEmailRecoveryFailedVMDelegate: class {
    func retry()
}

class PopUpPasswordEmailRecoveryFailedVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpPasswordEmailRecoveryFailedVMDelegate?
    
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
