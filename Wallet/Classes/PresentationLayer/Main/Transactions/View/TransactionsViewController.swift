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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        output.willMoveToParentVC()
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
        transactionsTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);
        transactionsTableView.tableFooterView = UIView()
    }
}
