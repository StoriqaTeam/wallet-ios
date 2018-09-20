//
//  BiometryQuickLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class BiometryQuickLaunchViewController: BaseQuickLaunchViewController {

    var output: BiometryQuickLaunchViewOutput!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureInterface()
    }
    
    private func configureInterface() {
        //TODO: image
        imageView.image = #imageLiteral(resourceName: "quickLaunch")
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
        
        switch biometryType {
        case .touchId:
            title = "touchId_quick_launch_title".localized()
            buttonTitle = "use_touchId".localized()
        case .faceId:
            title = "faceId_quick_launch_title".localized()
            buttonTitle = "use_faceId".localized()
        default:
            fatalError()
        }
        
        titleLabel.text = title
        actionButton.setTitle(buttonTitle, for: .normal)
    }

}
