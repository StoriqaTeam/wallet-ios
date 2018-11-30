//
//  TransactionDescriptionVeiw.swift
//  Wallet
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionDescriptionAddressViewDelegate: class {
    func addressDidTapped(address: String)
}


class TransactionDescriptionAddressView: LoadableFromXib {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var feeAmountLabel: UILabel!
    
    weak var delegate: TransactionDescriptionAddressViewDelegate?
    
    func configure(address: String, accountType: String, feeAmount: String) {
        self.addressLabel.text = address
        self.accountTypeLabel.text = "\(accountType) account"
        self.feeAmountLabel.text = feeAmount
        self.addressLabel.isUserInteractionEnabled = true
    }
    
    @IBAction func addressTapped(_ sender: Any) {
        guard let address = addressLabel.text else { return }
        delegate?.addressDidTapped(address: address)
    }
    
}
