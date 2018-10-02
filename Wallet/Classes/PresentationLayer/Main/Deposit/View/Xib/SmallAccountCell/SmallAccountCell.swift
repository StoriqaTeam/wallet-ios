//
//  SmallAccountCell.swift
//  Wallet
//
//  Created by user on 01.10.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class SmallAccountCell: UICollectionViewCell, AccountCellProtocol {
    
    @IBOutlet private var backgroundImage: UIImageView!
    @IBOutlet private var cryptoAmountLabel: UILabel!
    @IBOutlet private var fiatAmountLabel: UILabel!
    
    @IBOutlet private var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configWithAccountModel(_ model: Account) {
        backgroundImage.image = model.smallImageForType
        cryptoAmountLabel.text = model.cryptoAmount
        fiatAmountLabel.text = model.fiatAmount
        
        let color = model.textColorForType
        labels.forEach({ $0.textColor = color })
    }
    
}
