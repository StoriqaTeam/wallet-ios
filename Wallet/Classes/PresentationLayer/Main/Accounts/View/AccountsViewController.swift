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
    @IBOutlet weak var changeButton: RouteButton!
    @IBOutlet weak var depositButton: RouteButton!
    @IBOutlet weak var sendButton: RouteButton!
    

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        output.accountsCollectionView(accountsCollectionView)
        output.transactionTableView(lastTransactionsTableView)
        output.viewIsReady()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.configureCollections()
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
        configureNavBar()
        lastTransactionsTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        configureButtons()
    }
}


// MARK: - Private methods

extension AccountsViewController {
    private func configureNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .never
        setDarkTextNavigationBar()
    }
    
    private func configureButtons() {
        changeButton.configure(.deposit)
        changeButton.delegate = self
        sendButton.configure(.send)
        sendButton.delegate = self
        depositButton.configure(.deposit)
        depositButton.delegate = self
    }
}


// MARK: - RouteButtonDelegate

extension AccountsViewController: RouteButtonDelegate {
    func didTap(type: RouteButtonType) {
       output.handleCustomButton(type: type)
    }
}
