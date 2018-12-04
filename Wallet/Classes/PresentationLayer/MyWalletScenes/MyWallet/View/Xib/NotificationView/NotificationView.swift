//
//  NotificationView.swift
//  Wallet
//
//  Created by Storiqa on 04/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class NotificationView: LoadableFromXib {
    @IBOutlet private var textLabel: UILabel!
    
    func setMessage(_ msg: String) {
        textLabel.text = msg
        textLabel.font = Theme.Font.smallMediumWeightText
        textLabel.sizeToFit()
    }
    
}
