//
//  TransactionDescriptionVeiw.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class TransactionDescriptionAddressView: LoadableFromXib {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var feeAmountLabel: UILabel!
    
    
    func configure(address: String, accountType: String, feeAmount: String) {
        self.addressLabel.text = address
        self.accountTypeLabel.text = "\(accountType) account"
        self.feeAmountLabel.text = feeAmount
    }
}
