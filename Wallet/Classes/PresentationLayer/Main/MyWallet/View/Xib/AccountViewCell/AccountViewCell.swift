//
//  AccountViewCell.swift
//  Wallet
//
//  Created by user on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

protocol AccountCellProtocol {
    func configWithAccountModel(_ model: Account)
    func dropShadow()
}

extension AccountCellProtocol where Self: UICollectionViewCell {
    
    func dropShadow() {
        dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: 10, height: 15), radius: 12, scale: true)
    }
    
}

class AccountViewCell: UICollectionViewCell, AccountCellProtocol {

    @IBOutlet private var backgroundImage: UIImageView!
    @IBOutlet private var cryptoAmountLabel: UILabel!
    @IBOutlet private var fiatAmountLabel: UILabel!
    @IBOutlet private var holderName: UILabel!
    
    @IBOutlet private var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configWithAccountModel(_ model: Account) {
        backgroundImage.image = model.imageForType
        cryptoAmountLabel.text = model.cryptoAmount
        fiatAmountLabel.text = model.fiatAmount
        holderName.text = model.holderName
        
        let color = model.textColorForType
        labels.forEach({ $0.textColor = color })
    }
    
}
