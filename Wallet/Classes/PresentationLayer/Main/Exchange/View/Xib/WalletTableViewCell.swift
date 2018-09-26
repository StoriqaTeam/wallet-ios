//
//  CurrencyTableViewCell.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var currencyDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellStyle()
    }

    func configure(wallet: WalletType) {
        currencyDescription.text = wallet.description
        switch wallet {
        case .btc:
            currencyImage.image = UIImage(named: "bitcoinWallet")
        case .eth:
            currencyImage.image = UIImage(named: "ethWallet")
        case .stq:
            currencyImage.image = UIImage(named: "stqWallet")
        case .fiat:
            currencyImage.image = UIImage(named: "fiatWallet")
        }
    }
}


// MARK: - Private methods

extension WalletTableViewCell {
    private func setCellStyle() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
}
