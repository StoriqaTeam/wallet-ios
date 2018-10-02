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
    @IBOutlet private var gradientView: UIView!
    
    // Properties
    private var editBlock: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configInterface()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topRight, .bottomRight], radius: 12)
        setGradient()
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
        sendingTitleLabel.text = "sending".localized()
        currencyImageView.tintColor = .white
    }
    
    private func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [ UIColor(red: 55/255, green: 145/255, blue: 221/255, alpha: 1).cgColor,
                                 UIColor(red: 46/255, green: 103/255, blue: 196/255, alpha: 1).cgColor ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.layer.addSublayer(gradientLayer)
    }
    
}
