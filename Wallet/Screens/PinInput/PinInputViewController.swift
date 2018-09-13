//
//  PinInputViewController.swift
//  Wallet
//
//  Created by user on 16.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class PinInputViewController: UIViewController {
    @IBOutlet private var passwordStackView: UIStackView!
    @IBOutlet private var greetingContainerView: UIView!
    @IBOutlet private var greetingVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet private var greetingLabel: UILabel!
    @IBOutlet private var userPhotoImageView: UIImageView!
    @IBOutlet private var userPhotoContainerView: ActivityIndicatorView!
    
    //MARK: Property
    var passwordContainerView: PasswordContainerView!
    let kPasswordDigit = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constants.Sizes.isSmallScreen {
            greetingContainerView.isHidden = true
            greetingVerticalSpacingConstraint.constant = 0
            greetingLabel.text = ""
        } else {
            greetingLabel.text = UserInfo.shared.name + ", good day"
        }
        
        userPhotoImageView.image = UserInfo.shared.photo
        userPhotoImageView.roundCorners(radius: userPhotoImageView.frame.height / 2)
        userPhotoImageView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        
        //create PasswordContainerView
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit)
        passwordContainerView.delegate = self
        
        //customize password UI
        passwordContainerView.tintColor = UIColor.mainBlue
        passwordContainerView.highlightedColor = UIColor.mainBlue
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

extension PinInputViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        if validation(input) {
            validationSuccess()
        } else {
            validationFail()
        }
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        if success {
            self.validationSuccess()
        } else {
            passwordContainerView.clearInput()
            if let error = error,
                let message = BiometricsAuthErrorParser.errorMessageForLAErrorCode(error: error) {
                print(message)
                self.showAlert(message: message)
            }
        }
    }
}

private extension PinInputViewController {
    func validation(_ input: String) -> Bool {
        return input == "1234"
    }
    
    func validationSuccess() {
        print("*️⃣ success!")
        showActivityIndicator()
    }
    
    func validationFail() {
        print("*️⃣ failure!")
        passwordContainerView.wrongPassword()
    }
    
    func showActivityIndicator() {
        userPhotoContainerView.showActivityIndicator()
    }
    
    func hideActivityIndicator() {
        userPhotoContainerView.hideActivityIndicator()
    }
}
