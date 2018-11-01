//
//  PopUpChangePasswordFailedVM.swift
//  Wallet
//
//  Created by Tata Gri on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PopUpChangePasswordFailedVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    
    init(message: String) {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "generalErrorIcon"),
                                   title: "smth_went_wrong".localized(),
                                   text: message,
                                   actionButtonTitle: "ok".localized(),
                                   hasCloseButton: false)
    }
    
    func performAction() { }
}
