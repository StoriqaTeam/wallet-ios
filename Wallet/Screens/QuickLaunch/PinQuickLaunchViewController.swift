//
//  PinQuickLaunchViewController.swift
//  Wallet
//
//  Created by user on 17.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PinQuickLaunchViewController: QuickLaunchViewController {
    override func config() {
        titleLabel.text = "pin_quick_launch_title".localized()
        actionButton.setTitle("set_up_pin".localized(), for: .normal)
    }
    
    override func performAction(_ sender: UIButton) {
        guard let navigationController = navigationController else {
            log.warn("navigationController is nil")
            return
        }
        
        if let vc = Storyboard.quickLaunch.viewController(identifier: "PinSetupVC") {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    override func cancelSetup(_ sender: UIButton) {
        guard let navigationController = navigationController else {
            log.warn("navigationController is nil")
            return
        }
        
        if let vc = Storyboard.quickLaunch.viewController(identifier: "TouchIdQuickLaunchVC") {
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
