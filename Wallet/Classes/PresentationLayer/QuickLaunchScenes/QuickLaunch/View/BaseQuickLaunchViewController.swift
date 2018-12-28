//
//  BaseQuickLaunchViewController.swift
//  Wallet
//
//  Created by Storiqa on 20.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class BaseQuickLaunchViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel?
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var cancelButton: ColoredFramelessButton?
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        disableBackNavigation()
    }
    
    private func configureInterface() {
        view.backgroundColor = Theme.Color.backgroundColor
        title = ""
        
        titleLabel.font = Theme.Font.title
        subtitleLabel?.font = Theme.Font.subtitle
        titleLabel.textColor = Theme.Color.Text.main
        subtitleLabel?.textColor = Theme.Color.Text.main.withAlphaComponent(0.5)
        cancelButton?.setTitle(Strings.QuickLaunch.cancelButton, for: .normal)
    }
    
    private func disableBackNavigation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.isNavigationBarHidden = true
        navigationItem.hidesBackButton = true
    }
}
