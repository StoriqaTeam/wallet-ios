//
//  AppInfoViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 28/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class AppInfoViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.AppInfo

    var output: AppInfoViewOutput!
    
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var displayNameTitle: UILabel!
    
    @IBOutlet private var appVersionLabel: UILabel!
    @IBOutlet private var appVersionTitle: UILabel!
    
    @IBOutlet private var bundleIdLabel: UILabel!
    @IBOutlet private var bundleIdTitle: UILabel!
    
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
}


// MARK: - AppInfoViewInput

extension AppInfoViewController: AppInfoViewInput {
    func setupInitialState(displayName: String,
                           bundleId: String,
                           appVersion: String) {
        appVersionLabel.text = appVersion
        displayNameLabel.text = displayName
        bundleIdLabel.text = bundleId
        
        configureInterface()
    }
    
}


// MARK: - Private methods

extension AppInfoViewController {
    
    func configureInterface() {
        view.backgroundColor = Theme.Color.backgroundColor
        
        appVersionLabel.font = Theme.Font.smallText
        appVersionTitle.font = Theme.Font.smallText
        displayNameLabel.font = Theme.Font.smallText
        displayNameTitle.font = Theme.Font.smallText
        bundleIdLabel.font = Theme.Font.smallText
        bundleIdTitle.font = Theme.Font.smallText
        
        appVersionLabel.textColor = Theme.Color.Text.main
        displayNameLabel.textColor = Theme.Color.Text.main
        bundleIdLabel.textColor = Theme.Color.Text.main
        appVersionTitle.textColor = Theme.Color.Text.lightGrey
        displayNameTitle.textColor = Theme.Color.Text.lightGrey
        bundleIdTitle.textColor = Theme.Color.Text.lightGrey
        
        appVersionTitle.text = LocalizedStrings.appVersionTitle
        displayNameTitle.text = LocalizedStrings.displayNameTitle
        bundleIdTitle.text = LocalizedStrings.bundleIdTitle
        
        #if DEBUG
        #else
        bundleIdTitle.superview?.removeFromSuperview()
        #endif
    }
    
}
