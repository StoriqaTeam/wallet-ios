//
//  PopUpPasswordRecoveryConfirmFailedVM.swift
//  Wallet
//
//  Created by user on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpPasswordRecoveryConfirmFailedVMDelegate: class {
    func retry()
}

class PopUpPasswordRecoveryConfirmFailedVM: PopUpViewModelProtocol {
    weak var delegate: PopUpPasswordRecoveryConfirmFailedVMDelegate?
    var apperance: PopUpApperance
    
    init(message: String) {
        //TODO: image, title, action
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "faceid"),
                                   title: "smth_went_wrong".localized(),
                                   text: message,
                                   attributedText: nil,
                                   actionButtonTitle: "try_again".localized(),
                                   hasCloseButton: true)
    }
    
    func performAction() {
        delegate?.retry()
    }
}
