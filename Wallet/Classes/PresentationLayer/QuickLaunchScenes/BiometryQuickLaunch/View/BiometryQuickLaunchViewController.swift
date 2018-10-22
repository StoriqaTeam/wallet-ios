//
//  BiometryQuickLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class BiometryQuickLaunchViewController: BaseQuickLaunchViewController {

    typealias Localization = Strings.BiometryQuickLaunch
    
    var output: BiometryQuickLaunchViewOutput!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    // MARK: Actions
    
    @IBAction func performAction(_ sender: UIButton) {
        output.performAction()
    }
    
    @IBAction func cancelSetup(_ sender: UIButton) {
        output.cancelSetup()
    }
    
}


// MARK: - BiometryQuickLaunchViewInput

extension BiometryQuickLaunchViewController: BiometryQuickLaunchViewInput {
    
    func setupInitialState(biometryType: BiometricAuthType) {
        
        let title: String
        let buttonTitle: String
        let image: UIImage
        
        switch biometryType {
        case .touchId:
            title = Localization.touchIdTitle
            buttonTitle = Localization.touchIdButton
            image = #imageLiteral(resourceName: "touchIdQuickLaunch")
        case .faceId:
            title = Localization.touchIdTitle
            buttonTitle = Localization.faceIdButton
            image = #imageLiteral(resourceName: "faceIdQuickLaunch")
        default:
            fatalError("BiometryQuickLaunch view must not be shown in case of no biometryType")
        }
        
        imageView.image = image
        titleLabel.text = title
        actionButton.setTitle(buttonTitle, for: .normal)
    }

}
