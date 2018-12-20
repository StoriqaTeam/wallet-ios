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
        appVersionLabel.font = Theme.Font.smallText
        appVersionLabel.textColor = Theme.Color.Text.blackMain
        appVersionTitle.font = Theme.Font.smallText
        appVersionTitle.textColor = Theme.Color.Text.captionGrey
        appVersionTitle.text = LocalizedStrings.appVersionTitle
        
        displayNameLabel.font = Theme.Font.smallText
        displayNameLabel.textColor = Theme.Color.Text.blackMain
        displayNameTitle.font = Theme.Font.smallText
        displayNameTitle.textColor = Theme.Color.Text.captionGrey
        displayNameTitle.text = LocalizedStrings.displayNameTitle
        
        bundleIdLabel.font = Theme.Font.smallText
        bundleIdLabel.textColor = Theme.Color.Text.blackMain
        bundleIdTitle.font = Theme.Font.smallText
        bundleIdTitle.textColor = Theme.Color.Text.captionGrey
        bundleIdTitle.text = LocalizedStrings.bundleIdTitle
    }
    
}
