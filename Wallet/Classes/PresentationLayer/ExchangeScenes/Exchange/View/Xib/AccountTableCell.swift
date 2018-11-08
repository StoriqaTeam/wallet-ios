//
//  AccountTableCell.swift
//  Wallet
//
//  Created by Storiqa on 04/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class AccountTableCell: UITableViewCell {
    
    @IBOutlet private var currencyImage: UIImageView!
    @IBOutlet var accountName: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accountName.font = UIFont.systemFont(ofSize: 19)
        amountLabel.font = UIFont.systemFont(ofSize: 15)
        amountLabel.textColor = Theme.Text.Color.captionGrey
        currencyImage.tintColor = Theme.Color.brightSkyBlue
    }
    
    func configure(image: UIImage, accountName: String, amount: String) {
        self.currencyImage.image = image
        self.accountName.text = accountName
        self.amountLabel.text = amount
    }
    
}
