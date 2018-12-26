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
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "mailIcon"),
                                   title: Localization.emailSentTitle,
                                   text: Localization.registerDeviceEmailMessage,
                                   actionButtonTitle: Localization.okButton,
                                   hasCloseButton: false)
    }
    
    func performAction() { }
}
