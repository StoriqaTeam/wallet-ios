//
//  QuickLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class QuickLaunchViewController: UIViewController {

    var output: QuickLaunchViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel?
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    // MARK: Variables
    
    private var actionBlock: (()->())?
    private var cancelBlock: (()->())?

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureInterface()
    }
    
    private func configureInterface() {
        subtitleLabel?.textColor = .greyishBrown
        cancelButton.setTitle("do_not_use".localized(), for: .normal)
    }
    
    // MARK: Actions
    
    @IBAction func performAction(_ sender: UIButton) {
        actionBlock?()
    }
    
    @IBAction func cancelSetup(_ sender: UIButton) {
        cancelBlock?()
    }
}


// MARK: - QuickLaunchViewInput

extension QuickLaunchViewController: QuickLaunchViewInput {
    func setupInitialState(screenApperance: QuickLaunchScreenApperance) {
        /*
         titleLabel.text = "quick_launch_title".localized()
         subtitleLabel?.text = "quick_launch_subtitle".localized()
         actionButton.setTitle("set_up_quick_launch".localized(), for: .normal)
         */
        
        titleLabel.text = screenApperance.title
        imageView.image = screenApperance.image
        subtitleLabel?.text = screenApperance.subtitle
        actionButton.setTitle(screenApperance.actionButtonTitle, for: .normal)
        actionBlock = screenApperance.actionBlock
        cancelBlock = screenApperance.cancelBlock
        
    }
    
}
