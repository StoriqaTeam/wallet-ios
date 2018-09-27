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
    @IBOutlet private var gradientView: UIView!
    

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.accountsCollectionView(accountsCollectionView)
        output.transactionTableView(lastTransactionsTableView)
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.configureCollections()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGradientView()
    }
    
    
    // MARK: - Actions

    @IBAction func viewAllPressed(_ sender: UIButton) {
        output.viewAllPressed()
    }
    
}


// MARK: - AccountsViewInput

extension AccountsViewController: AccountsViewInput {
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
    }

    func setupInitialState() {
        configureTableView()
        configureButtons()
        accountsPageControl.isUserInteractionEnabled = false
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
        lastTransactionsTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        lastTransactionsTableView.tableFooterView = UIView()
    }
    
    private func configureGradientView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [ UIColor(red: 0.2549019608, green: 0.7176470588, blue: 0.9568627451, alpha: 1).cgColor,
                                 UIColor(red: 0.1764705882, green: 0.3921568627, blue: 0.7607843137, alpha: 1).cgColor ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientView.layer.addSublayer(gradientLayer)
    }
}


// MARK: - RouteButtonDelegate

extension AccountsViewController: RouteButtonDelegate {
    func didTap(type: RouteButtonType) {
       output.handleCustomButton(type: type)
    }
}
