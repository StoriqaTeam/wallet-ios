//
//  SendingHeaderView.swift
//  Wallet
//
//  Created by user on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class SendingHeaderView: UIView {

    // IBOutlets
    @IBOutlet private var sendingTitleLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var convertedAmountLabel: UILabel!
    @IBOutlet private var currencyImageView: UIImageView!
    @IBOutlet private var editButton: UIButton!
    
    // Properties
    private var editBlock: (()->())?
    private var contentView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.captionGrey
        self.roundCorners([.topRight, .bottomRight], radius: 12)
        sendingTitleLabel.text = "sending".localized()
    }
    
    func setup(amount: String, convertedAmount: String, editBlock: @escaping (()->())) {
        self.editBlock = editBlock
        amountLabel.text = amount
        convertedAmountLabel.text = convertedAmount
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    // IBActions
    @IBAction private func editButtonPressed() {
        editBlock?()
    }
}


// MARK: - Private methods

extension SendingHeaderView {
    private func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SendingHeaderView", bundle: bundle)
        guard let authView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Fail to load SocialNetworkAuthView")
        }
        
        authView.frame = bounds
        addSubview(authView)
        contentView = authView
    }
}
