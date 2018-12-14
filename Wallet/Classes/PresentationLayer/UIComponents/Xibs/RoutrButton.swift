//
//  ChangeButton.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
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
    
    typealias LocalizedStrings = Strings.Accounts
    
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
            title.text = LocalizedStrings.exchangeButton
        case .deposit:
            title.text = LocalizedStrings.depositButton
            image.image = UIImage(named: "DepositBtnImg")
        case .send:
            title.text = LocalizedStrings.sendButton
            image.image = UIImage(named: "SendBtnImage")
        }
        
        title.textColor = UIColor.white
        image.tintColor = UIColor.white
        
        roundCorners(radius: 8)
    }
}
