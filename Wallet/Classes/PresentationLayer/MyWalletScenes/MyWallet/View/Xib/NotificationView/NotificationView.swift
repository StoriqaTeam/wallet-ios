//
//  NotificationView.swift
//  Wallet
//
//  Created by Storiqa on 04/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class NotificationView: LoadableFromXib {
    
    typealias LocalizedStrings = Strings.MyWallet
    
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var stqContainer: UIView!
    @IBOutlet private var ethContainer: UIView!
    @IBOutlet private var btcContainer: UIView!
    @IBOutlet private var stqLabel: UILabel!
    @IBOutlet private var ethLabel: UILabel!
    @IBOutlet private var btcLabel: UILabel!
    
    let attrString = NSAttributedString(string: LocalizedStrings.newFundsReceivedMessage)
    let amountAttribues = [NSAttributedString.Key.font: Theme.Font.smallBoldText!,
                           NSAttributedString.Key.foregroundColor: Theme.Color.Text.main]
    
    func setAmounts(stq: String?, eth: String?, btc: String?) {
        configureInterface()
        
        if let stq = stq {
            let mutableAttrString = NSMutableAttributedString(attributedString: attrString)
            let amountAttrString = NSAttributedString(string: stq, attributes: amountAttribues)
            mutableAttrString.append(amountAttrString)
            
            stqLabel.attributedText = mutableAttrString
            stqLabel.sizeToFit()
        } else {
            stqContainer.removeFromSuperview()
        }
        
        if let eth = eth {
            let mutableAttrString = NSMutableAttributedString(attributedString: attrString)
            let amountAttrString = NSAttributedString(string: eth, attributes: amountAttribues)
            mutableAttrString.append(amountAttrString)
            
            ethLabel.attributedText = mutableAttrString
            ethLabel.sizeToFit()
        } else {
            ethContainer.removeFromSuperview()
        }
        
        if let btc = btc {
            let mutableAttrString = NSMutableAttributedString(attributedString: attrString)
            let amountAttrString = NSAttributedString(string: btc, attributes: amountAttribues)
            mutableAttrString.append(amountAttrString)
            
            btcLabel.attributedText = mutableAttrString
            btcLabel.sizeToFit()
        } else {
            btcContainer.removeFromSuperview()
        }
    }
}


// MARK: Private methods

extension NotificationView {
    private func configureInterface() {
        backgroundView.backgroundColor = Theme.Color.Notification.background
        backgroundView.roundCorners(radius: 6)
        
        stqLabel.font = Theme.Font.smallText
        ethLabel.font = Theme.Font.smallText
        btcLabel.font = Theme.Font.smallText
        stqLabel.textColor = Theme.Color.Text.lightGrey
        ethLabel.textColor = Theme.Color.Text.lightGrey
        btcLabel.textColor = Theme.Color.Text.lightGrey
    }
}
