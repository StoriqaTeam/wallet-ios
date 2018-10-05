//
//  PinSetupViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinSetupViewController: UIViewController {
    var output: PinSetupViewOutput!

    @IBOutlet private var pinContainerView: PinContainerView!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        disableBackNavigation()
        output.pinContainer(pinContainerView)
    }
    
    private func disableBackNavigation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
    }
}


// MARK: - PinSetupViewInput

extension PinSetupViewController: PinSetupViewInput {
    
    func setupInitialState() {

    }

    func setTitle(title: String) {
        self.title = title
    }
    
    func clearInput() {
        pinContainerView.clearInput()
    }
    
    func wrongInput() {
        pinContainerView.wrongPassword()
    }
    
}
