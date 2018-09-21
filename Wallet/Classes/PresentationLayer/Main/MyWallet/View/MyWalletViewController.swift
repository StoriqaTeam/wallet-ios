//
//  MyWalletViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MyWalletViewController: UIViewController {

    var output: MyWalletViewOutput!

    @IBOutlet weak var walletTabBarItem: UITabBarItem!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureNavBar()
    }

}


// MARK: - MyWalletViewInput

extension MyWalletViewController: MyWalletViewInput {
    
    func setupInitialState() {

    }

}


// MARK: - Private methods

extension MyWalletViewController {
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.topItem?.title = "My wallet"
    }
}
