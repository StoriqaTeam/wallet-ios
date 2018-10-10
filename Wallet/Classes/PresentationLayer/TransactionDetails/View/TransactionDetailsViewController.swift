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
    
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

}


// MARK: - TransactionDetailsViewInput

extension TransactionDetailsViewController: TransactionDetailsViewInput {
    
    func setupInitialState(transaction: TransactionDisplayable) {
        detailView.configure(transaction: transaction)
        addDescriptionView(for: transaction)
    }

}


// MARK: - Private methods

extension TransactionDetailsViewController {
    
    private func addDescriptionView(for transaction: TransactionDisplayable) {
        
        switch transaction.opponent {
        case .address(address: let address):
            let descriptionView = TransactionDescriptionAddressView()
            descriptionView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionView)
            
            descriptionView.translatesAutoresizingMaskIntoConstraints = false
            descriptionView.widthAnchor.constraint(equalToConstant: detailView.bounds.width).isActive = true
            descriptionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
            descriptionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            descriptionView.topAnchor.constraint(equalTo: detailView.bottomAnchor, constant: 20).isActive = true
            descriptionView.configure(address: address, accountType: transaction.currency.ISO, feeAmount: transaction.feeAmountString)
            
        case .contact(contact: let contact):
            let descriptionView = TransactionDescriptionContactView()
            descriptionView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionView)
            
            descriptionView.translatesAutoresizingMaskIntoConstraints = false
            descriptionView.widthAnchor.constraint(equalToConstant: detailView.bounds.width).isActive = true
            descriptionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
            descriptionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            descriptionView.topAnchor.constraint(equalTo: detailView.bottomAnchor, constant: 20).isActive = true
            descriptionView.configure(address: contact.cryptoAddress ?? "",
                                      accountType: transaction.currency.ISO,
                                      contact: "\(contact.givenName) \(contact.familyName)",
                                      feeAmount: transaction.feeAmountString)
        }
    }
}
