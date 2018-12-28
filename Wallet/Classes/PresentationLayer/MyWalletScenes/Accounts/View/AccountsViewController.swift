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
    @IBOutlet private var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var lastTransactionsTitle: UILabel!
    @IBOutlet private var viewAllButton: ThinButton!
    @IBOutlet private var viewAllHeightConstraint: NSLayoutConstraint!
    

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
        
        UIView.animate(withDuration: 0.25, delay: 0.2, options: [], animations: {
            self.lastTransactionsTitle.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        output.configureCollections()
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
            UIView.animate(withDuration: 0.25) {
                self.viewAllButton.alpha = 1
            }
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
        configureAppearence()
        accountsPageControl.numberOfPages = numberOfPages
    }
    
    func setCollectionHeight(_ height: CGFloat) {
        collectionHeightConstraint.constant = height
    }
    
    func setViewAllButtonHidden(_ hidden: Bool) {
        viewAllButton.isHidden = hidden
        viewAllHeightConstraint.constant = 0
        viewAllHeightConstraint.isActive = hidden
    }
}


// MARK: - Private methods

extension AccountsViewController {
    
    private func configureAppearence() {
        view.backgroundColor = Theme.Color.backgroundColor
        lastTransactionsTitle.font = Theme.Font.smallMediumWeightText
        lastTransactionsTitle.textColor = Theme.Color.Text.lightGrey
        lastTransactionsTitle.text = LocalizedStrings.lastTransactionsTitle
        accountsPageControl.isUserInteractionEnabled = false
        
        viewAllButton.title = LocalizedStrings.viewAllButton
        
        let gradientHeight: CGFloat = 34
        viewAllButton.superview?.backgroundColor = Theme.Color.backgroundColor
        viewAllButton.superview?.gradientView(
            colors: [UIColor.clear.cgColor, Theme.Color.backgroundColor.cgColor],
            frame: CGRect(x: 0, y: -gradientHeight, width: Constants.Sizes.screenWidth, height: gradientHeight),
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 1.0))
        lastTransactionsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: gradientHeight, right: 0)
    }
}
