//
//  PasswordInputPasswordInputViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordInputViewController: UIViewController {

    var output: PasswordInputViewOutput!
    
    @IBOutlet private var passwordStackView: UIStackView!
    @IBOutlet private var greetingContainerView: UIView!
    @IBOutlet private var greetingVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet private var greetingLabel: UILabel!
    @IBOutlet private var userPhotoImageView: UIImageView!
    @IBOutlet private var userPhotoContainerView: ActivityIndicatorView!
    
    private var passwordContainerView: PasswordContainerView!
    

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserPhoto()
        configureGreeting()
        passwordContainerView = output.setPasswordView(in: passwordStackView)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

}


// MARK: - PasswordInputViewInput

extension PasswordInputViewController: PasswordInputViewInput {
    
    func setupInitialState() { }
    
    func inputSucceed() {
        print("*️⃣ success!")
        showActivityIndicator()
    }
    
    func inputFailed() {
        print("*️⃣ failure!")
        passwordContainerView.wrongPassword()
    }
    
    func clearInput() {
        passwordContainerView.clearInput()
    }

}

// MARK: - Private methods

extension PasswordInputViewController {
    
    private func configureGreeting() {
        if Constants.Sizes.isSmallScreen {
            greetingContainerView.isHidden = true
            greetingVerticalSpacingConstraint.constant = 0
            greetingLabel.text = ""
        } else {
            greetingLabel.text = UserInfo.shared.name + "greeting".localized()
        }
    }
    
    private func configureUserPhoto() {
        userPhotoImageView.image = UserInfo.shared.photo
        userPhotoImageView.roundCorners(radius: userPhotoImageView.frame.height / 2)
        userPhotoImageView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
    }
    
    private func showActivityIndicator() {
        userPhotoContainerView.showActivityIndicator()
    }
    
    private func hideActivityIndicator() {
        userPhotoContainerView.hideActivityIndicator()
    }
}
