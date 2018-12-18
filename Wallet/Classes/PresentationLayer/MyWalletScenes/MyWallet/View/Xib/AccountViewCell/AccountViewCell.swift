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
    @IBOutlet private var cryptoAmountLabel: UILabel!
    @IBOutlet private var fiatAmountLabel: UILabel!
    @IBOutlet private var holderNameLabel: UILabel?
    @IBOutlet private var labels: [UILabel]!
    
    func configureWith(cryptoAmount: String,
                       fiatAmount: String,
                       holderName: String,
                       textColor: UIColor,
                       backgroundImage: UIImage) {
        cryptoAmountLabel.text = cryptoAmount
        fiatAmountLabel.text = "≈" + fiatAmount
        holderNameLabel?.text = holderName
        backgroundImageView.image = backgroundImage
        labels.forEach({ $0.textColor = textColor })
        
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
