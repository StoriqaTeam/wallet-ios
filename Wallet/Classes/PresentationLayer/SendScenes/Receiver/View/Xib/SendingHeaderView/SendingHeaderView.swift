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
    private var editBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configInterface()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topRight, .bottomRight], radius: 12)
        setGradient()
    }
    
    func setup(apperance: SendingHeaderData, editBlock: @escaping (() -> Void)) {
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
        gradientView.gradientView(colors: Theme.Gradient.sendingHeaderGradient,
                     frame: bounds,
                     startPoint: CGPoint(x: 0.0, y: 1.0),
                     endPoint: CGPoint(x: 1.0, y: 1.0))
    }
    
}
