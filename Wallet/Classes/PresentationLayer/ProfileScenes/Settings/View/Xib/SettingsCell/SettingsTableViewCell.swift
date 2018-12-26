//
//  SettingsCell.swift
//  Wallet
//
//  Created by Storiqa on 13/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet private var settingsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(info: String) {
        configureAppearence()
        settingsLabel.text = info
    }
    
}


// MARK: - Private methods

extension SettingsTableViewCell {
    private func configureAppearence() {
        backgroundColor = Theme.Color.backgroundColor
        selectionStyle = .none
        settingsLabel.textColor = .white
        settingsLabel.font = Theme.Font.SettingsTableView.cellTitle
    }
}
