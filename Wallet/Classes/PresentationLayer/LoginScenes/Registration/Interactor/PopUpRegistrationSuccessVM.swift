//
//  PopUpRegistrationSuccessVM.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpRegistrationSuccessVMDelegate: class {
    func okButtonPressed()
}

class PopUpRegistrationSuccessVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpRegistrationSuccessVMDelegate?
    
    init(email: String) {
        let attrText = NSMutableAttributedString(string: Localization.registrationMessage,
                                                 attributes: [.font: Theme.Font.PopUp.subtitle!,
                                                              .foregroundColor: Theme.Color.Text.main.withAlphaComponent(0.7)])
        attrText.append(NSAttributedString(string: email,
                                           attributes: [.font: Theme.Font.smallMediumWeightText!,
                                                        .foregroundColor: Theme.Color.Text.main]))
        
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "mailIcon"),
                                   title: Localization.emailSentTitle,
                                   attributedText: attrText,
                                   actionButtonTitle: Localization.okButton,
                                   hasCloseButton: false)
    }
    
    func performAction() {
        delegate?.okButtonPressed()
    }
}
