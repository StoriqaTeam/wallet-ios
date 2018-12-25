//
//  TRansactionDetailsContactView.swift
//  Wallet
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionDescriptionDelegate: class {
    func addressDidTapped(address: String)
}


class TransactionDescriptionView: LoadableFromXib {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var pendingView: UIImageView!
    
    weak var delegate: TransactionDescriptionDelegate?
    
    private var addressToCopy: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearence()
    }
    
    func configure(address: String,
                   contact: String,
                   isPending: Bool,
                   timestamp: String) {
        
        self.addressToCopy = address
        self.addresslabel.text = address.maskCryptoAddress()
        self.contactLabel.text = contact
        self.timestampLabel.text = timestamp
        self.pendingView.isHidden = !isPending
        self.pendingLabel.isHidden = !isPending
    }
    
    @IBAction func copyAddress(_ sender: Any) {
        guard let address = addressToCopy else { return }
        delegate?.addressDidTapped(address: address)
    }
}


// MARK: - Private methods

extension TransactionDescriptionView {
    private func configureAppearence() {
        backgroundView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        fromLabel.textColor = Theme.Color.Text.lightGrey
        fromLabel.font = Theme.Font.smallMediumWeightText
        
        addresslabel.font = Theme.Font.Label.medium
        addresslabel.textColor = .white
        
        contactLabel.font = Theme.Font.Label.regular
        contactLabel.textColor = Theme.Color.Button.enabledBackground
        
        timestampLabel.font = Theme.Font.smallMediumWeightText
        timestampLabel.textColor = Theme.Color.Text.lightGrey
        
        pendingLabel.font = Theme.Font.smallMediumWeightText
        pendingLabel.textColor = Theme.Color.mainOrange
        
        copyButton.setImage(UIImage(named: "copyIcon"), for: .normal)
        copyButton.tintColor = Theme.Color.Text.lightGrey
        
        pendingView.image = UIImage(named: "pendingIcon")
    }
}
