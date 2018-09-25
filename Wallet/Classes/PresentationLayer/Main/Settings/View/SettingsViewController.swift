//
//  SettingsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    var output: SettingsViewOutput!


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    @IBAction func resetPressed(_ sender: UIButton) {
        output.resetApplication()
    }
}


// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewInput {
    
    func setupInitialState() {

    }

}
