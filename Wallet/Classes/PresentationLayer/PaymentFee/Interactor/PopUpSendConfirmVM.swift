//
//  PopUpSendConfirmVM.swift
//  Wallet
//
//  Created by user on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpSendConfirmVMDelegate: class {
    func confirmTransaction()
}

class PopUpSendConfirmVM: PopUpViewModelProtocol {
    var apperance: PopUpApperance
    weak var delegate: PopUpSendConfirmVMDelegate?
    
    init(amount: String, address: String) {
        let boldTextAttributes = [NSAttributedStringKey.font: UIFont.smallMediumWeightText,
                                  NSAttributedStringKey.foregroundColor: UIColor.black]
        
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString(string: "you_are_going_to_send".localized() + " \n"))
        attrText.append(NSAttributedString(string: amount, attributes: boldTextAttributes))
        attrText.append(NSAttributedString(string: " " + "to" + " "))
        attrText.append(NSAttributedString(string: address, attributes: boldTextAttributes))
        
        //TODO: image
        apperance = PopUpApperance(image: #imageLiteral(resourceName: "faceid"),
                                   title: "confirm_send".localized(),
                                   text: nil,
                                   attributedText: attrText,
                                   actionButtonTitle: "confirm_transaction".localized(),
                                   hasCloseButton: true)
    }
    
    func performAction() {
        delegate?.confirmTransaction()
    }
    
}