//
//  AccountViewCell.swift
//  Wallet
//
//  Created by Storiqa on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class AccountViewCell: UICollectionViewCell {

    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var smallCryptoAmountLabel: UILabel!
    @IBOutlet private var bigCryptoAmountLabel: UILabel?
    @IBOutlet private var fiatAmountLabel: UILabel!
    @IBOutlet private var accountNameLabel: UILabel?
    @IBOutlet private var currencyNameLabel: UILabel?
    
    func configureWith(cryptoAmount: String,
                       cryptoAmountWithoutCurrency: String,
                       fiatAmount: String,
                       accountName: String,
                       currency: String,
                       textColor: UIColor,
                       backgroundImage: UIImage) {
        smallCryptoAmountLabel.text = cryptoAmount
        bigCryptoAmountLabel?.text = cryptoAmountWithoutCurrency
        fiatAmountLabel.text = fiatAmount
        accountNameLabel?.text = accountName
        currencyNameLabel?.text = currency
        backgroundImageView.image = backgroundImage
        
        configureInterface(textColor: textColor)
        roundCorners(radius: 12)
    }
    
    func dropShadow() {
        dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: 10, height: 15), radius: 12, scale: true)
    }
    
    // FIXME: for debug only
    func setTestColor(_ index: Int) {
        let colors = [UIColor.red,
                      UIColor.blue,
                      UIColor.orange,
                      UIColor.yellow,
                      UIColor.green,
                      UIColor.darkGray,
                      UIColor.lightGray,
                      UIColor.cyan,
                      UIColor.magenta,
                      UIColor.purple,
                      UIColor.brown]
        
        let newInd = index % colors.count
        
        backgroundImageView.image = nil
        backgroundImageView.backgroundColor = colors[newInd]
    }
    
    override open func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        let snapshotView = UIView(frame: self.frame)
        if let snapshotOfContentView = self.contentView.snapshotView(afterScreenUpdates: afterUpdates) {
            snapshotView.addSubview(snapshotOfContentView)
        }
        snapshotView.roundCorners(radius: 12)
        return snapshotView
    }
}


// MARK: Private methods

extension AccountViewCell {
    func configureInterface(textColor: UIColor) {
        smallCryptoAmountLabel.textColor = textColor
        bigCryptoAmountLabel?.textColor = textColor
        fiatAmountLabel.textColor = textColor
        accountNameLabel?.textColor = textColor
        currencyNameLabel?.textColor = textColor
        
        smallCryptoAmountLabel.font = Theme.Font.smallBoldText
        bigCryptoAmountLabel?.font = Theme.Font.largeText
        fiatAmountLabel.font = Theme.Font.smallMediumWeightText
        accountNameLabel?.font = Theme.Font.smallMediumWeightText
        currencyNameLabel?.font = Theme.Font.smallMediumWeightText
    }
}
