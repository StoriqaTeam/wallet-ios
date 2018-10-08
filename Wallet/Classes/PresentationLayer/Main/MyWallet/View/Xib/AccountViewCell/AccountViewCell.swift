//
//  AccountViewCell.swift
//  Wallet
//
//  Created by user on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class AccountViewCell: UICollectionViewCell {

    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var cryptoAmountLabel: UILabel!
    @IBOutlet private var fiatAmountLabel: UILabel!
    @IBOutlet private var holderNameLabel: UILabel?
    
    @IBOutlet private var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(cryptoAmount: String,
                       fiatAmount: String,
                       holderName: String,
                       textColor: UIColor,
                       backgroundImage: UIImage) {
        cryptoAmountLabel.text = cryptoAmount
        fiatAmountLabel.text = fiatAmount
        holderNameLabel?.text = holderName
        backgroundImageView.image = backgroundImage
        
        labels.forEach({ $0.textColor = textColor })
    }
    
    func dropShadow() {
        dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: 10, height: 15), radius: 12, scale: true)
    }
    
}
