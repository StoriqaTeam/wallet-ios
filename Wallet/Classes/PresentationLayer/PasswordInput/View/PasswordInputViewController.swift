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
    private let kPasswordDigit = 4


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserPhoto()
        configureGreeting()
        configurePasswordView()
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
    
    func pinValidationSuccess() {
        print("*️⃣ success!")
        showActivityIndicator()
    }
    
    func pinValidationFail() {
        print("*️⃣ failure!")
        passwordContainerView.wrongPassword()
    }

}


// MARK: - PasswordInputCompleteProtocol

extension PasswordInputViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        output.passwordInputComplete(input)
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: String?) {
        if success {
            pinValidationSuccess()
        } else {
            passwordContainerView.clearInput()
            if let error = error {
                log.warn(error)
                self.showAlert(message: error)
            }
        }
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
    
    private func configurePasswordView() {
        
        //create PasswordContainerView
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit)
        passwordContainerView.delegate = self
        
        //customize password UI
        passwordContainerView.tintColor = UIColor.mainBlue
        passwordContainerView.highlightedColor = UIColor.mainBlue
    }
    
    private func configureUserPhoto() {
        userPhotoImageView.image = UserInfo.shared.photo
        userPhotoImageView.roundCorners(radius: userPhotoImageView.frame.height / 2)
        userPhotoImageView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
    }
    
    // FIXME: - Вынести в отдельный сервис
    private func validation(_ input: String) -> Bool {
        return input == "1234"
    }
    
    private func showActivityIndicator() {
        userPhotoContainerView.showActivityIndicator()
    }
    
    private func hideActivityIndicator() {
        userPhotoContainerView.hideActivityIndicator()
    }
}
