//
//  TRansactionDetailsContactView.swift
//  Wallet
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class  TransactionDescriptionContactView: LoadableFromXib {
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var feeAmountLabel: UILabel!
    
    weak var delegate: TransactionDescriptionAddressViewDelegate?
    
    
    func configure(address: String,
                   accountType: String,
                   contact: String,
                   feeAmount: String) {
        
        self.addresslabel.text = address
        self.accountTypeLabel.text = "\(accountType) account"
        self.contactLabel.text = contact
        self.feeAmountLabel.text = feeAmount
        self.addresslabel.isUserInteractionEnabled = true

    }
    
    @IBAction func addresstapped(_ sender: Any) {
        guard let address = addresslabel.text else { return }
        delegate?.addressDidTapped(address: address)
    }
}
