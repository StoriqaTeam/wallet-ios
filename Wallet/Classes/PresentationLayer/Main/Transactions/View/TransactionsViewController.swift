//
//  TransactionsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionsViewController: UIViewController {

    var output: TransactionsViewOutput!

    @IBOutlet weak var transactionsTableView: UITableView!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.transactionTableView(transactionsTableView)
        output.viewIsReady()
    }

}


// MARK: - TransactionsViewInput

extension TransactionsViewController: TransactionsViewInput {
    
    func setupInitialState() {
        configureTableView()
    }

}


// MARK: Private methods

extension TransactionsViewController {
    private func configureTableView() {
        transactionsTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        transactionsTableView.tableFooterView = UIView()
    }
}
