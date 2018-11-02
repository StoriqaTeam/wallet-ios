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
                                   title: "smth_went_wrong".localized(),
                                   text: message,
                                   actionButtonTitle: "try_again".localized(),
                                   hasCloseButton: true)
    }
    
    func performAction() {
        delegate?.retryButtonPressed()
    }
    
    func cancelAction() {
        delegate?.cancelButtonPressed()
    }
}
