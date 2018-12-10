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
    
    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
    @IBOutlet private var lastTransactionsTableView: UITableView!
    @IBOutlet private var changeButton: RouteButton!
    @IBOutlet private var depositButton: RouteButton!
    @IBOutlet private var sendButton: RouteButton!
    

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.accountsCollectionView(accountsCollectionView)
        output.transactionTableView(lastTransactionsTableView)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.configureCollections()
        output.viewWillAppear()
        accountsCollectionView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        output.configureCollections()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions

    @IBAction func viewAllPressed(_ sender: UIButton) {
        output.viewAllPressed()
    }
    
}


// MARK: - AccountsViewInput

extension AccountsViewController: AccountsViewInput {
    
    func showAccounts() {
        accountsCollectionView.isHidden = false
    }
    
    func updatePagesCount(_ count: Int) {
        accountsPageControl.numberOfPages = count
    }
    
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
    }

    func setupInitialState(numberOfPages: Int) {
        configureTableView()
        configureButtons()
        accountsPageControl.isUserInteractionEnabled = false
        accountsPageControl.numberOfPages = numberOfPages
    }
}


// MARK: - Private methods

extension AccountsViewController {
    private func configureButtons() {
        changeButton.configure(.change)
        changeButton.delegate = self
        sendButton.configure(.send)
        sendButton.delegate = self
        depositButton.configure(.deposit)
        depositButton.delegate = self
    }
    
    private func configureTableView() {
        lastTransactionsTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        lastTransactionsTableView.tableFooterView = UIView()
    }
}


// MARK: - RouteButtonDelegate

extension AccountsViewController: RouteButtonDelegate {
    func didTap(type: RouteButtonType) {
       output.handleCustomButton(type: type)
    }
}
