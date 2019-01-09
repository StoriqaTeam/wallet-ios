//
//  TransactionDetailsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionDetailsViewController: UIViewController {

    typealias LocalizedStrings = Strings.TransactionDetails
    
    var output: TransactionDetailsViewOutput!

    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet weak var cryptoAmountLabel: UILabel!
    @IBOutlet weak var blockchainTransactionButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var fiatAmountLabel: UILabel!
    @IBOutlet weak var feeAmountLabel: UILabel!
    @IBOutlet weak var descriptionView: TransactionDescriptionView!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    @IBAction func viewOnBlockchainTapped(_ sender: UIButton) {
        output.viewInBlockchain()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}


// MARK: - TransactionDetailsViewInput

extension TransactionDetailsViewController: TransactionDetailsViewInput {
    
    func setupInitialState(transaction: TransactionDisplayable) {
        configureDefaultAppearence()
        configureAppearence(transaction: transaction)
        configureDescriptionView(transaction: transaction)
        view.layoutSubviews()
    }
    
    func setupViewInBlockchainButtonVisibility(isVisible: Bool) {
        blockchainTransactionButton.isHidden = !isVisible
    }
    
    func setupBlockchainButton(title: String) {
        blockchainTransactionButton.titleLabel?.text = title
    }

}


// MARK: - TransactionDescriptionDelegate

extension TransactionDetailsViewController: TransactionDescriptionDelegate {
    func addressDidTapped(address: String) {
        output.addressTapped(address)
    }
    
}


// MARK: - Private methods

extension TransactionDetailsViewController {
    
    private func configureDefaultAppearence() {
        view.backgroundColor = Theme.Color.backgroundColor
        gradientView.backgroundColor = .clear
        cryptoAmountLabel.font = Theme.Font.largeText
        cryptoAmountLabel.tintColor = .white
        fiatAmountLabel.font = Theme.Font.subtitle
        fiatAmountLabel.tintColor = .white
        feeAmountLabel.font = Theme.Font.smallText
        feeAmountLabel.tintColor = Theme.Color.opaqueWhite
        directionImageView.contentMode = .center
    }
    
    private func configureAppearence(transaction: TransactionDisplayable) {
        let direction = transaction.direction
        let directionImage: UIImage?
        let cryptoAmountString: String
        let fiatAmountString: String
        let gradientColors: [CGColor]
        
        if direction == .receive {
            gradientColors = Theme.Color.Gradient.Details.detailBlueGradient
            directionImage = UIImage(named: "receiveIconMedium")
            cryptoAmountString = "+ \(transaction.cryptoAmountString)"
            fiatAmountString = "+ \(transaction.fiatAmountString)"
        } else {
            gradientColors = Theme.Color.Gradient.Details.detailsRedGradient
            directionImage = UIImage(named: "sendIconMedium")
            cryptoAmountString = "- \(transaction.cryptoAmountString)"
            fiatAmountString = "- \(transaction.fiatAmountString)"
        }
        
        
        feeAmountLabel.text = "Fee \(transaction.feeAmountString)"
        gradientView.alpha = 0.31
        gradientView.gradientView(colors: gradientColors,
                                  frame: view.bounds,
                                  startPoint: CGPoint(x: 0.5, y: 0.0),
                                  endPoint: CGPoint(x: 0.5, y: 1.0))
        directionImageView.image = directionImage
        cryptoAmountLabel.text = cryptoAmountString
        fiatAmountLabel.text = fiatAmountString
    }
    
    func configureDescriptionView(transaction: TransactionDisplayable) {
        descriptionView.delegate = self
        
        let isPending = transaction.transaction.status == .pending
        let timestamp = "\(transaction.timestamp)"
        let direction: String
        
        switch transaction.direction {
        case .receive:
            direction = LocalizedStrings.fromLabel
        case .send:
            direction = LocalizedStrings.toLabel
        }
        
        let addr: String
        let contact: String
        
        switch transaction.opponent {
        case .address(let address):
            addr = address
            contact = ""
        case .txAccount(let account, let address):
            addr = address
            contact = account.ownerName
        }
        
        descriptionView.configure(address: addr,
                                  contact: contact,
                                  isPending: isPending,
                                  timestamp: timestamp,
                                  directionLabel: direction)
        
    }
}
