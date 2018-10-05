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
    @IBOutlet private var cryptoAmountLabel: UILabel!
    @IBOutlet private var fiatAmountLabel: UILabel!
    @IBOutlet private var holderName: UILabel?
    
    @IBOutlet private var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(account: AccountDisplayable) {
        cryptoAmountLabel.text = account.cryptoAmount
        fiatAmountLabel.text = account.fiatAmount
        holderName?.text = account.holderName
        
        let color = account.textColorForType
        labels.forEach({ $0.textColor = color })
    }
    
    func dropShadow() {
        dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: 10, height: 15), radius: 12, scale: true)
    }
    
    func setBackgroundImage(_ image: UIImage) {
        backgroundImage.image = image
    }
}
