//
//  AccountsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class AccountsViewController: UIViewController {

    var output: AccountsViewOutput!
    
    @IBOutlet weak var accountsCollectionView: UICollectionView!
    @IBOutlet weak var accountsPageControl: UIPageControl!
    @IBOutlet weak var lastTransactionsTableView: UITableView!
    

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        output.accountsCollectionView(accountsCollectionView)
        output.transactionTableView(lastTransactionsTableView)
        output.viewIsReady()
    }
    
    
    // MARK: - Actions

    @IBAction func viewAllPressed(_ sender: UIButton) {
        showAlert(title:"", message: "Need Transaction list screen design")
    }
    
}


// MARK: - AccountsViewInput

extension AccountsViewController: AccountsViewInput {
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
    }

    func setupInitialState() {

    }
}


// MARK: - Private methods

extension AccountsViewController {
    private func configureNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .never
        setDarkTextNavigationBar()
    }
}
