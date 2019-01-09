//
//  DeviceRegisterConfirmViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DeviceRegisterConfirmViewController: UIViewController {

    var output: DeviceRegisterConfirmViewOutput!


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

}


// MARK: - DeviceRegisterConfirmViewInput

extension DeviceRegisterConfirmViewController: DeviceRegisterConfirmViewInput {
    
    func setupInitialState() {
        view.backgroundColor = Theme.Color.backgroundColor
    }

}
