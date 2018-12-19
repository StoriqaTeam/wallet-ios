//
//  PopUpDefaultFailureVM.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PopUpDefaultFailureVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    
    init(message: String) {
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "generalErrorIcon"),
                                   title: Localization.failureTitle,
                                   text: message,
                                   actionButtonTitle: Localization.okButton,
                                   hasCloseButton: false)
    }
    
    func performAction() { }
}
