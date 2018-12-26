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
        configureSeparator()
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
    
    private func configureSeparator() {
        let separatorRect = CGRect(x: 20,
                                   y: contentView.frame.size.height - 1,
                                   width: contentView.frame.size.width - 60,
                                   height: 1)
        let seperatorView = UIView(frame: separatorRect)
        seperatorView.alpha = 0.5
        seperatorView.gradientView(colors: Theme.Color.Gradient.underlineGradient,
                                   frame: seperatorView.bounds,
                                   startPoint: CGPoint(x: 0.0, y: 0.5),
                                   endPoint: CGPoint(x: 1.0, y: 0.5))
        
        contentView.addSubview(seperatorView)
    }
}
