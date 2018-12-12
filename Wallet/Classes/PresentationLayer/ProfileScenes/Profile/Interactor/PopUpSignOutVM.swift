//
//  PopUpSignOutVM.swift
//  Wallet
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpSignOutVMDelegate: class {
    func signOut()
}

class PopUpSignOutVM: PopUpViewModelProtocol {
    var apperance = PopUpApperance(image: #imageLiteral(resourceName: "signOutIcon"),
                                   title: Localization.signOutTitle,
                                   text: Localization.signOutMessage,
                                   actionButtonTitle: Localization.signOutButton,
                                   hasCloseButton: true,
                                   closeButtonTitle: Localization.noButton)
    weak var delegate: PopUpSignOutVMDelegate?
    
    func performAction() {
        delegate?.signOut()
    }
}
