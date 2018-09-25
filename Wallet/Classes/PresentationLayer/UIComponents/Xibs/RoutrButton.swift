//
//  ChangeButton.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

enum RouteButtonType {
    case change
    case send
    case deposit
}

protocol RouteButtonDelegate: class {
    func didTap(type: RouteButtonType)
}

class RouteButton: LoadableFromXib {
    
    weak var delegate: RouteButtonDelegate!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    var type: RouteButtonType!
    
    @IBAction func handlePan(_ sender: UITapGestureRecognizer) {
        delegate.didTap(type: type)
    }
    
    func configure(_ type: RouteButtonType) {
        self.type = type
        switch type {
        case .change:
            image.image = UIImage(named: "ChangeBtnImg")
            title.text = "Change"
        case .deposit:
            title.text = "Deposit"
            image.image = UIImage(named: "DepositBtnImg")
        case .send:
            title.text = "Send"
            image.image = UIImage(named: "SendBtnImage")
        }
        
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Theme.Button.Color.greyBorder.cgColor
    }
}


