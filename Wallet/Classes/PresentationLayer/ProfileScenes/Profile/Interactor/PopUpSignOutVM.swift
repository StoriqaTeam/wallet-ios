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
                                   title: "sign_out_title".localized(),
                                   text: "sign_out_text".localized(),
                                   actionButtonTitle: "sure".localized(),
                                   hasCloseButton: true,
                                   closeButtonTitle: "not_now".localized())
    weak var delegate: PopUpSignOutVMDelegate?
    
    func performAction() {
        delegate?.signOut()
    }
}
