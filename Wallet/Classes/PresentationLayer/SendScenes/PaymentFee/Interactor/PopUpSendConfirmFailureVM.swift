//
//  PopUpSendConfirmFailureVM.swift
//  Wallet
//
//  Created by Tata Gri on 29/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PopUpSendConfirmFailureVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpSendConfirmVMDelegate?
    
    init(message: String) {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "generalErrorIcon"),
                                   title: "smth_went_wrong".localized(),
                                   text: message,
                                   actionButtonTitle: "ok".localized(),
                                   hasCloseButton: false)
    }
    
    func performAction() { }
    
}
