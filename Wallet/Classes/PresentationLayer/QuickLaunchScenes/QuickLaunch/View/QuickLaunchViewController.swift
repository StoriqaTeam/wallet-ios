//
//  QuickLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class QuickLaunchViewController: BaseQuickLaunchViewController {

    var output: QuickLaunchViewOutput!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureInterface()
    }
    
    private func configureInterface() {
        titleLabel.text = "quick_launch_title".localized()
        subtitleLabel?.text = "quick_launch_subtitle".localized()
        actionButton.setTitle("set_up_quick_launch".localized(), for: .normal)
    }
    
    // MARK: Actions
    
    @IBAction func performAction(_ sender: UIButton) {
        output.performAction()
        
    }
    
    @IBAction func cancelSetup(_ sender: UIButton) {
        output.cancelSetup()
    }
}


// MARK: - QuickLaunchViewInput

extension QuickLaunchViewController: QuickLaunchViewInput {
    
    func setupInitialState() { }
    
}
