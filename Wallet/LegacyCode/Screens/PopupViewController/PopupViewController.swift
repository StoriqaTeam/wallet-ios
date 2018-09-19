//
//  PopupViewController.swift
//  Wallet
//
//  Created by user on 13.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PopupViewController: UIViewController {

    private var actionBlock: (()->())?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        view.backgroundColor = .clear
    }
    
}
