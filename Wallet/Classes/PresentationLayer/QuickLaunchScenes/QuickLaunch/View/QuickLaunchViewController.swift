//
//  QuickLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class QuickLaunchViewController: BaseQuickLaunchViewController {
    
    typealias Localized = Strings.QuickLaunch

    var output: QuickLaunchViewOutput!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureInterface()
    }
    
    private func configureInterface() {
        titleLabel.text = Localized.quickLaunchTitle
        subtitleLabel?.text = Localized.quickLaunchSubtitle
        actionButton.setTitle(Localized.setUpButtonTitle, for: .normal)
    }
    
    // MARK: Actions
    
    @IBAction func performAction(_ sender: UIButton) {
        output.performAction()
    }
}


// MARK: - QuickLaunchViewInput

extension QuickLaunchViewController: QuickLaunchViewInput {
    
    func setupInitialState() { }
    
}
