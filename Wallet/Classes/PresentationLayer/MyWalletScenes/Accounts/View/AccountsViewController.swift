//
//  AccountsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class AccountsViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.Accounts

    var output: AccountsViewOutput!
    
    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
    @IBOutlet private var lastTransactionsTableView: UITableView!
    @IBOutlet private var changeButton: RouteButton!
    @IBOutlet private var depositButton: RouteButton!
    @IBOutlet private var sendButton: RouteButton!
    @IBOutlet private var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var lastTransactionsTitle: UILabel!
    @IBOutlet private var viewAllButton: UIButton!
    

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.accountsCollectionView(accountsCollectionView)
        output.transactionTableView(lastTransactionsTableView)
        output.viewIsReady()
        
        accountsCollectionView.alpha = 0
        lastTransactionsTitle.alpha = 0
        viewAllButton.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.configureCollections()
        output.viewWillAppear()
        
        UIView.animate(withDuration: 0.25, delay: 0.2, options: [], animations: {
            self.lastTransactionsTitle.alpha = 1
            self.viewAllButton.alpha = 1
        }, completion: nil)
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
    
    func showAccounts(completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.25, animations: {
            self.accountsCollectionView.alpha = 1
        }, completion: {_ in
            completion()
        })
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
        lastTransactionsTitle.text = LocalizedStrings.lastTransactionsTitle
        viewAllButton.setTitle(LocalizedStrings.viewAllButton, for: .normal)
    }
    
    func setCollectionHeight(_ height: CGFloat) {
        collectionHeightConstraint.constant = height
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
