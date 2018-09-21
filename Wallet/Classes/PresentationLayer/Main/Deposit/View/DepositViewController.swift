//
//  DepositViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DepositViewController: UIViewController {

    var output: DepositViewOutput!


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

}


// MARK: - DepositViewInput

extension DepositViewController: DepositViewInput {
    
    func setupInitialState() {

    }

}
