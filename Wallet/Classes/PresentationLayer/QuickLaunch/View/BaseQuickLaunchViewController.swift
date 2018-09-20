//
//  BaseQuickLaunchViewController.swift
//  Wallet
//
//  Created by user on 20.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class BaseQuickLaunchViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel?
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
    }
    
    private func configureInterface() {
        titleLabel.font = UIFont.title
        subtitleLabel?.font = UIFont.subtitle
        subtitleLabel?.textColor = .greyishBrown
        cancelButton.setTitle("do_not_use".localized(), for: .normal)
    }
}
