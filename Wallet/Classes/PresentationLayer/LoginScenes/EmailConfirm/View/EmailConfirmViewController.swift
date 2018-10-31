//
//  EmailConfirmViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class EmailConfirmViewController: UIViewController {

    var output: EmailConfirmViewOutput!


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

}


// MARK: - EmailConfirmViewInput

extension EmailConfirmViewController: EmailConfirmViewInput {
    
    func setupInitialState() {

    }

}
