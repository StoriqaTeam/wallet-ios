//
//  TransactionDetailsView.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class TransactionDetailView: LoadableFromXib {
    
    @IBOutlet weak var cryptoAmountLabel: UILabel!
    @IBOutlet weak var fiatAmountLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    func configure(transaction: Transaction) {
        cryptoAmountLabel.text = transaction.cryptoAmount.string
        fiatAmountLabel.text = transaction.fiatAmount.string
        timestampLabel.text = "\(transaction.timestamp)"
        configureAppearence(for: transaction)
    }

}


// MARK: - Private methods

extension TransactionDetailView {
    private func configureAppearence(for transaction: Transaction) {
        let status = transaction.status
        let direction = transaction.direction
        let colors: [CGColor]
        let cryptoLabelColor: UIColor
        let directionImage: UIImage?
        let cryptoAmountString: String
        
        if direction == .receive {
            directionImage = UIImage(named: "receiveTransactionIcon")
            colors = Theme.Gradient.Details.detailsGreenGradient
            cryptoLabelColor = Theme.Text.Color.detailsGreen
            cryptoAmountString = "+ \(transaction.cryptoAmount.string)"
        } else {
            colors = Theme.Gradient.Details.detailsRedGradient
            cryptoLabelColor = Theme.Text.Color.detailsRed
            directionImage = UIImage(named: "sendTransactionIcon")
            cryptoAmountString = "- \(transaction.cryptoAmount.string)"
        }
        
        cryptoAmountLabel.textColor = cryptoLabelColor
        cryptoAmountLabel.text = cryptoAmountString
        directionImageView.image = directionImage
        pendingLabel.isHidden = status != .pending
        backgroundView.gradientView(colors: colors,
                                    frame: self.bounds,
                                    startPoint: CGPoint(x: 1.0, y: 0.5),
                                    endPoint: CGPoint(x: 0.0, y: 0.5))
    }
}
