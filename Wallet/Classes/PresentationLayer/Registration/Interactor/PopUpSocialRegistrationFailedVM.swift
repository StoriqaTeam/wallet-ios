//
//  PopUpSocialRegistrationFailedVM.swift
//  Wallet
//
//  Created by user on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PopUpSocialRegistrationFailedVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    
    init(message: String) {
        //TODO: image, action
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "faceid"),
                                   title: "smth_went_wrong".localized(),
                                   text: message,
                                   attributedText: nil,
                                   actionButtonTitle: "ok".localized(),
                                   hasCloseButton: false)
    }
    
    func performAction() { }
}