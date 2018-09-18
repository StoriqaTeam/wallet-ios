//
//  QuickLaunchViewController.swift
//  Wallet
//
//  Created by user on 17.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class QuickLaunchViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel? {
        didSet {
            subtitleLabel?.textColor = .greyishBrown
        }
    }
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var cancelButton: UIButton! {
        didSet {
            cancelButton.setTitle("do_not_use".localized(), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        titleLabel.text = "quick_launch_title".localized()
        subtitleLabel?.text = "quick_launch_subtitle".localized()
        actionButton.setTitle("set_up_quick_launch".localized(), for: .normal)
    }
    
    @IBAction func performAction(_ sender: UIButton) {
        guard let navigationController = navigationController else {
            log.warn("navigationController is nil")
            return
        }
        
        if let vc = Storyboard.quickLaunch.viewController(identifier: "PinQuickLaunchVC") {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cancelSetup(_ sender: UIButton) {
        dismissViewController()
    }
}
