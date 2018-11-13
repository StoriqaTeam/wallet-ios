//
//  SettingsCell.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 13/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet private var settingsLabel: UILabel!
    
    func configure(info: String) {
        settingsLabel.text = info
    }
}
