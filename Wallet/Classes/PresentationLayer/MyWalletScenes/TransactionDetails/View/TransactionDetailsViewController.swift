//
//  TransactionDetailsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionDetailsViewController: UIViewController {

    var output: TransactionDetailsViewOutput!

    @IBOutlet weak var detailView: TransactionDetailView!
    @IBOutlet weak var blockchainTransactionButton: UIButton!
    
    
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
}


// MARK: - TransactionDetailsViewInput

extension TransactionDetailsViewController: TransactionDetailsViewInput {
    
    func setupInitialState(transaction: TransactionDisplayable) {
        detailView.configure(transaction: transaction)
        addDescriptionView(for: transaction)
        view.layoutSubviews()
    }
    
    func setupViewInBlockchainButtonVisibility(isVisible: Bool) {
        blockchainTransactionButton.isHidden = !isVisible
    }
    
    func setupBlockchainButton(title: String) {
        blockchainTransactionButton.titleLabel?.text = title
    }

}


// MARK: - TransactionDescriptionAddressViewDelegate

extension TransactionDetailsViewController: TransactionDescriptionAddressViewDelegate {
    func addressDidTapped(address: String) {
        output.addressTapped(address)
    }
    
}


// MARK: - Private methods

extension TransactionDetailsViewController {
    
    private func addDescriptionView(for transaction: TransactionDisplayable) {
        
        let descriptionView: UIView
        
        switch transaction.opponent {
        case .address(let address):
            let view = TransactionDescriptionAddressView()
            view.configure(address: address,
                           accountType: transaction.currency.ISO,
                           feeAmount: transaction.feeAmountString)
            descriptionView = view
            view.delegate = self
            
        case .txAccount(let account, let address):
            let view = TransactionDescriptionContactView()
            view.configure(address: address,
                           accountType: transaction.currency.ISO,
                           contact: account.ownerName,
                           feeAmount: transaction.feeAmountString)
            descriptionView = view
            view.delegate = self
        }
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.widthAnchor.constraint(equalTo: detailView.widthAnchor).isActive = true
        descriptionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionView.topAnchor.constraint(equalTo: detailView.bottomAnchor, constant: 20).isActive = true
        descriptionView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: 20).isActive = true
    }
}
