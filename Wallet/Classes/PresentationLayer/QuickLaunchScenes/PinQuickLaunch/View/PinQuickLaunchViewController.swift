//
//  PinQuickLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinQuickLaunchViewController: BaseQuickLaunchViewController {

    typealias Localization = Strings.PinQuickLaunch
    
    var output: PinQuickLaunchViewOutput!

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureInterface()
    }
    
    private func configureInterface() {
        titleLabel.text = Localization.title
        actionButton.setTitle(Localization.button, for: .normal)
    }
    
    // MARK: Actions
    
    @IBAction func performAction(_ sender: UIButton) {
        output.performAction()
    }

}


// MARK: - PinQuickLaunchViewInput

extension PinQuickLaunchViewController: PinQuickLaunchViewInput {
    
    func setupInitialState() {

    }

}
