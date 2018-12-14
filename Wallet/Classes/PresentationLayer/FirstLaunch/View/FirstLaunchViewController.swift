//
//  FirstLaunchFirstLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class FirstLaunchViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.FirstLaunch

    var output: FirstLaunchViewOutput!
    
    @IBOutlet private var getStartedButton: DefaultButton!
    @IBOutlet private var signInButton: BaseButton!
    
    
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
        getStartedButton.setTitle(LocalizedStrings.getStartedButton, for: .normal)
        signInButton.setTitle(LocalizedStrings.signInButton, for: .normal)
    }
}
