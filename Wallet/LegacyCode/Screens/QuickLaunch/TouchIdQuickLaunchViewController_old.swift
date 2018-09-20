//
//  TouchIdQuickLaunchViewController.swift
//  Wallet
//
//  Created by user on 17.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class TouchIdQuickLaunchViewController_old: QuickLaunchViewController_old {
    override func config() {
        titleLabel.text = "touchId_quick_launch_title".localized()
        actionButton.setTitle("use_touchId".localized(), for: .normal)
    }
    
    override func performAction(_ sender: UIButton) {
        //TODO: сохранять данные для входа в кейчейн + флажок о входе
    }
    
    override func cancelSetup(_ sender: UIButton) {
        dismissViewController()
    }
}
