//
//  ErrorView.swift
//  Wallet
//
//  Created by user on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class ErrorView: LoadableFromXib {
    @IBOutlet private var errorImageView: UIImageView!
    @IBOutlet private var messageLabel: UILabel!
    
    func setup(image: UIImage, text: String) {
        configInterface()
        
        errorImageView.image = image
        messageLabel.text = text
        layoutIfNeeded()
    }
    
    private func configInterface() {
        errorImageView.tintColor = UIColor.cloudyBlue
        messageLabel.textColor = UIColor.bluegrey
        messageLabel.font = UIFont.smallText
    }
}
