//
//  TransactionTableViewCell.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var cryptoAmountLabel: UILabel!
    @IBOutlet weak var fiatAmountlabel: UILabel!
    @IBOutlet weak var directionOpponentLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    func configureWith(transaction: TransactionDisplayable) {
        configureAppearence(transaction: transaction)
    }
}


// MARK: - Private mehods

extension TransactionTableViewCell {
    private func configureAppearence(transaction: TransactionDisplayable) {
        let direction = transaction.direction
        currencyLabel.text = transaction.currency.symbol
        timestampLabel.text = transaction.timestamp
        
        switch transaction.opponent {
        case .address(let address):
            opponentLabel.text = address
        case .txAccount(let account, _):
            opponentLabel.text = account.ownerName
        }
        
        switch direction {
        case .send:
            directionLabel.text = "Send"
            directionOpponentLabel.text = "to"
            cryptoAmountLabel.text = "- \(transaction.cryptoAmountString)"
            fiatAmountlabel.text = "- \(transaction.fiatAmountString)"
            directionImageView.image = UIImage(named: "SendStatusImg")
        case .receive:
            directionLabel.text = "Receive"
            directionOpponentLabel.text = "from"
            cryptoAmountLabel.text = "+ \(transaction.cryptoAmountString)"
            fiatAmountlabel.text = "+\(transaction.fiatAmountString)"
            directionImageView.image = UIImage(named: "ReceiveStatusImg")
        }
    }
}
