//
//  TransactionDetailsView.swift
//  Wallet
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class TransactionDetailView: LoadableFromXib {
    
    @IBOutlet private var cryptoAmountLabel: UILabel!
    @IBOutlet private var fiatAmountLabel: UILabel!
    @IBOutlet private var timestampLabel: UILabel!
    @IBOutlet private var pendingLabel: UILabel!
    @IBOutlet private var directionImageView: UIImageView!
    @IBOutlet private var backgroundView: UIView!
    
    private var gradientColors = [CGColor]()
    
    func configure(transaction: TransactionDisplayable) {
        cryptoAmountLabel.text = transaction.cryptoAmountString
        fiatAmountLabel.text = transaction.fiatAmountString
        timestampLabel.text = "\(transaction.timestamp)"
        configureAppearence(for: transaction)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.gradientView(colors: gradientColors,
                                    frame: self.bounds,
                                    startPoint: CGPoint(x: 1.0, y: 0.5),
                                    endPoint: CGPoint(x: 0.0, y: 0.5))
    }

}


// MARK: - Private methods

extension TransactionDetailView {
    private func configureAppearence(for transaction: TransactionDisplayable) {
        let direction = transaction.direction
        let cryptoLabelColor: UIColor
        let directionImage: UIImage?
        let cryptoAmountString: String
        
        if direction == .receive {
            gradientColors = Theme.Gradient.Details.detailsGreenGradient
            directionImage = UIImage(named: "receiveTransactionIcon")
            cryptoLabelColor = Theme.Text.Color.detailsGreen
            cryptoAmountString = "+ \(transaction.cryptoAmountString)"
        } else {
            gradientColors = Theme.Gradient.Details.detailsRedGradient
            cryptoLabelColor = Theme.Text.Color.detailsRed
            directionImage = UIImage(named: "sendTransactionIcon")
            cryptoAmountString = "- \(transaction.cryptoAmountString)"
        }
        
        cryptoAmountLabel.textColor = cryptoLabelColor
        cryptoAmountLabel.text = cryptoAmountString
        directionImageView.image = directionImage
    }

}
