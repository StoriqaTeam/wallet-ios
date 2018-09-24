//
//  PopUpPasswordEmailRecoverySuccessVM.swift
//  Wallet
//
//  Created by user on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpPasswordEmailRecoverySuccessVMDelegate: class {
    func closePasswordRecovery()
}

class PopUpPasswordEmailRecoverySuccessVM: PopUpViewModelProtocol {
    //TODO: image, title, text, action
    
    weak var delegate: PopUpPasswordEmailRecoverySuccessVMDelegate?
    var apperance = PopUpApperance(image: #imageLiteral(resourceName: "faceid"),
                                   title: "email_sent".localized(),
                                   text: "TODO: text",
                                   attributedText: nil,
                                   actionButtonTitle: "ok".localized(),
                                   hasCloseButton: false)
    
    
    func performAction() {
        delegate?.closePasswordRecovery()
    }
}
