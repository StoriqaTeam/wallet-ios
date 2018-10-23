//
//  PinInputPasswordInputViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinInputViewController: UIViewController {

    var output: PinInputViewOutput!
    typealias Localized = Strings.PinInput
    
    // MARK: IBOutlet
    
    @IBOutlet private var greetingContainerView: UIView!
    @IBOutlet private var greetingVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet private var greetingLabel: UILabel!
    @IBOutlet private var userPhotoImageView: UIImageView!
    @IBOutlet private var userPhotoContainerView: ActivityIndicatorView!
    @IBOutlet private var pinContainerView: PinContainerView!
    

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.pinContainer(pinContainerView)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: Life cycle
    
    @IBAction func iForgotPinPressed(_ sender: UIButton) {
        output.iForgotPinPressed()
    }

}


// MARK: - PinInputViewInput

extension PinInputViewController: PinInputViewInput {
    
    func setupInitialState(userPhoto: UIImage, userName: String) {
        configureUserPhoto(photo: userPhoto)
        configureGreeting(name: userName)
    }
    
    func inputSucceed() {
        showActivityIndicator()
        pinContainerView.completeInput()
    }
    
    func inputFailed() {
        log.debug("*️⃣ failure!")
        pinContainerView.wrongPassword()
        showAlert(message: "Wrong password")
    }
    
    func clearInput() {
        pinContainerView.clearInput()
    }

}

// MARK: - Private methods

extension PinInputViewController {
    
    private func configureGreeting(name: String) {
        if Device.model == .iPhoneSE {
            greetingContainerView.isHidden = true
            greetingVerticalSpacingConstraint.constant = 0
            greetingLabel.text = ""
        } else {
            greetingLabel.text = name + Localized.greetingLabelTitle
        }
    }
    
    private func configureUserPhoto(photo: UIImage) {
        userPhotoImageView.image = photo
        userPhotoImageView.roundCorners(radius: userPhotoImageView.frame.height / 2)
        userPhotoImageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    private func showActivityIndicator() {
        userPhotoContainerView.showActivityIndicator(linewidth: 2.0)
    }
    
    private func hideActivityIndicator() {
        userPhotoContainerView.hideActivityIndicator()
    }
}
