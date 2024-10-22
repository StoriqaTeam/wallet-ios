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
    @IBOutlet weak var secondAmountLabel: UILabel!
    @IBOutlet weak var directionOpponentLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    func configureWith(transaction: TransactionDisplayable) {
        selectionStyle = .none
        configureInterface()
        configureAppearence(transaction: transaction)
    }
}


// MARK: - Private mehods

extension TransactionTableViewCell {
    private func configureAppearence(transaction: TransactionDisplayable) {
        let direction = transaction.direction
        currencyLabel.text = transaction.currency.symbol
        timestampLabel.text = transaction.timestamp
        cryptoAmountLabel.text = transaction.cryptoAmountString
        secondAmountLabel.text = transaction.secondAmountString
        
        switch transaction.opponent {
        case .address(let address):
            opponentLabel.text = address.maskCryptoAddress()
        case .txAccount(let account, _):
            opponentLabel.text = account.ownerName
        }
        
        switch direction {
        case .send:
            directionLabel.text = "Sent"
            directionOpponentLabel.text = "to"
            directionImageView.image = UIImage(named: "SendStatusImg")
        case .receive:
            directionLabel.text = "Received"
            directionOpponentLabel.text = "from"
            directionImageView.image = UIImage(named: "ReceiveStatusImg")
        }
    }
    
    private func configureInterface() {
        backgroundColor = Theme.Color.backgroundColor
        contentView.backgroundColor = Theme.Color.backgroundColor
        
        directionLabel.textColor = .white
        directionLabel.font = Theme.Font.regularMedium
        currencyLabel.textColor = .white
        currencyLabel.font = Theme.Font.regularMedium
        cryptoAmountLabel.textColor = .white
        cryptoAmountLabel.font = Theme.Font.regularMedium
        secondAmountLabel.textColor = Theme.Color.Text.lightGrey
        secondAmountLabel.font = Theme.Font.smallMediumWeightText
        directionOpponentLabel.textColor = Theme.Color.Text.lightGrey
        directionOpponentLabel.font = Theme.Font.smallMediumWeightText
        opponentLabel.textColor = Theme.Color.Text.lightGrey
        opponentLabel.font = Theme.Font.smallMediumWeightText
        timestampLabel.textColor = Theme.Color.Text.lightGrey
        timestampLabel.font = Theme.Font.smallMediumWeightText
    }
}
