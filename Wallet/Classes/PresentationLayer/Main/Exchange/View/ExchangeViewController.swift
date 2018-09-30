//
//  ExchangeViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeViewController: UIViewController {

    var output: ExchangeViewOutput!

    @IBOutlet weak var accountsCollectionView: UICollectionView!
    @IBOutlet weak var accountsPageControl: UIPageControl!
    @IBOutlet weak var walletsTableView: UITableView!
    
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.accountsCollectionView(accountsCollectionView)
        output.walletsTableView(walletsTableView)
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.configureCollections()
    }
    
}


// MARK: - ExchangeViewInput

extension ExchangeViewController: ExchangeViewInput {
    func setupInitialState() {
        configureWalletsTableView()
        
        //FIXME: number of accounts for page control
    }
    
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
    }

}


// MARK: - Private methods

extension ExchangeViewController {
    
    private func configureWalletsTableView() {
        walletsTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        walletsTableView.tableFooterView = UIView()
        walletsTableView.isScrollEnabled = false
    }
}
