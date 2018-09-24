//
//  PopUpPasswordEmailRecoveryFailedVM.swift
//  Wallet
//
//  Created by user on 24.09.2018.
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
