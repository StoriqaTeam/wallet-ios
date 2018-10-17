//
//  FirstLaunchFirstLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class FirstLaunchViewController: UIViewController {

    var output: FirstLaunchViewOutput!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    @IBAction func getStartedPressed(_ sender: UIButton) {
        output.showRegistration()
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        output.showLogin()
    }
}


// MARK: - FirstLaunchViewInput

extension FirstLaunchViewController: FirstLaunchViewInput {
    
    func setupInitialState() {

    }
}
