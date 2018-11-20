//
//  PopUpDeviceRegisterEmailSentVM.swift
//  Wallet
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PopUpDeviceRegisterEmailSentVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    
    init() {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "successIcon"),
                                   title: "email_sent".localized(),
                                   text: "Check the mail! We sent instruction how to register your device",
                                   actionButtonTitle: "ok".localized(),
                                   hasCloseButton: false)
    }
    
    func performAction() { }
}
