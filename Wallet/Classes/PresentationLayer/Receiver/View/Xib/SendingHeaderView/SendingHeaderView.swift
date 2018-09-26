//
//  SendingHeaderView.swift
//  Wallet
//
//  Created by user on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

struct SendingHeaderData {
    let amount: String
    let amountInTransactionCurrency: String
    let currencyImage: UIImage
}

class SendingHeaderView: LoadableFromXib {
    
    // IBOutlets
    @IBOutlet private var sendingTitleLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var convertedAmountLabel: UILabel!
    @IBOutlet private var currencyImageView: UIImageView!
    @IBOutlet private var editButton: UIButton!
    
    // Properties
    private var editBlock: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configInterface()
    }
    
    func setup(apperance: SendingHeaderData, editBlock: @escaping (()->())) {
        amountLabel.text = apperance.amount
        convertedAmountLabel.text = apperance.amountInTransactionCurrency
        currencyImageView.image = apperance.currencyImage
        self.editBlock = editBlock
    }
    
    // IBActions
    @IBAction private func editButtonPressed() {
        editBlock?()
    }
}


// MARK: - Private methods

extension SendingHeaderView {
    
    private func configInterface() {
        
        backgroundColor = UIColor.captionGrey
        self.roundCorners([.topRight, .bottomRight], radius: 12)
        sendingTitleLabel.text = "sending".localized()
        currencyImageView.tintColor = .white
    }
    
}
