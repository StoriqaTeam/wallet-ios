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
        
        let color: UIColor
        
        switch type {
        case .change:
            image.image = UIImage(named: "ChangeBtnImg")
            title.text = "Change"
            color = UIColor.white
        case .deposit:
            title.text = "Deposit"
            image.image = UIImage(named: "DepositBtnImg")
            color = #colorLiteral(red: 0.4549019608, green: 0.9803921569, blue: 0.7019607843, alpha: 1)
        case .send:
            title.text = "Send"
            image.image = UIImage(named: "SendBtnImage")
            color = #colorLiteral(red: 0.9529411765, green: 0.662745098, blue: 0.6549019608, alpha: 1)
        }
        
        title.textColor = color
        image.tintColor = color
        
        roundCorners(radius: 8)
    }
}
