//
//  AccountViewCell.swift
//  Wallet
//
//  Created by user on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class AccountViewCell: UICollectionViewCell {

    @IBOutlet private var backgroundImage: UIImageView!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var convertedAmountLabel: UILabel!
    @IBOutlet private var holderName: UILabel!
    
    @IBOutlet private var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configWithAccountModel(_ model: AccountModel) {
        backgroundImage.image = model.imageForType
        amountLabel.text = model.cryptoAmount
        convertedAmountLabel.text = model.fiatAmount
        holderName.text = model.holderName
        
        let color = model.textColorForType
        labels.forEach({ $0.textColor = color })
    }
    
}
