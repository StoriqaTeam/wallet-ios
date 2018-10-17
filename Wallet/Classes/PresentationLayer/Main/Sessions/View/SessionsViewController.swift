//
//  SessionsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SessionsViewController: UIViewController {

    var output: SessionsViewOutput!


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

}


// MARK: - SessionsViewInput

extension SessionsViewController: SessionsViewInput {
    
    func setupInitialState() {

    }

}
