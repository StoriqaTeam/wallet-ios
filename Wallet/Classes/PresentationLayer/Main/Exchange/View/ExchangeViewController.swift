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

    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
    @IBOutlet private var walletsTableView: UITableView!
    @IBOutlet private var gradientView: UIView!
    
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGradientView()
    }
    
}


// MARK: - ExchangeViewInput

extension ExchangeViewController: ExchangeViewInput {
    func setupInitialState(numberOfPages: Int) {
        configureWalletsTableView()
        accountsPageControl.isUserInteractionEnabled = false
        accountsPageControl.numberOfPages = numberOfPages
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
