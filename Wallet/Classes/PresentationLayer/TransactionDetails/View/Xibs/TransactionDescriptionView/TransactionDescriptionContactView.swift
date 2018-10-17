//
//  TRansactionDetailsContactView.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class  TransactionDescriptionContactView: LoadableFromXib {
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var feeAmountLabel: UILabel!
    
    
    func configure(address: String,
                   accountType: String,
                   contact: String,
                   feeAmount: String) {
        
        self.addresslabel.text = address
        self.accountTypeLabel.text = "\(accountType) account"
        self.contactLabel.text = contact
        self.feeAmountLabel.text = feeAmount
    }
    
}
