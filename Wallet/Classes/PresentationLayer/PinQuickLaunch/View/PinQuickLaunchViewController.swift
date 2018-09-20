//
//  PinQuickLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinQuickLaunchViewController: BaseQuickLaunchViewController {

    var output: PinQuickLaunchViewOutput!

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureInterface()
    }
    
    private func configureInterface() {
        //TODO: image
        titleLabel.text = "pin_quick_launch_title".localized()
        imageView.image = #imageLiteral(resourceName: "quickLaunch")
        actionButton.setTitle("set_up_pin".localized(), for: .normal)
    }
    
    // MARK: Actions
    
    @IBAction func performAction(_ sender: UIButton) {
        output.performAction()
    }
    
    @IBAction func cancelSetup(_ sender: UIButton) {
        output.cancelSetup()
    }

}


// MARK: - PinQuickLaunchViewInput

extension PinQuickLaunchViewController: PinQuickLaunchViewInput {
    
    func setupInitialState() {

    }

}
