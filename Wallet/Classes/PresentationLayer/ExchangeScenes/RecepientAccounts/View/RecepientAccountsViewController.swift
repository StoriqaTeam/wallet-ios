//
//  RecepientAccountsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class RecepientAccountsViewController: UIViewController {

    var output: RecepientAccountsViewOutput!
    
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.accountsCollectionView(collectionView)
        output.viewIsReady()
    }

}


// MARK: - RecepientAccountsViewInput

extension RecepientAccountsViewController: RecepientAccountsViewInput {
    
    func setupInitialState() {

    }

}
