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
    
    
    
    //MARK: Property
    var passwordContainerView: PasswordContainerView!
    let kPasswordDigit = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constants.Sizes.isSmallScreen {
            greetingContainerView.isHidden = true
            greetingVerticalSpacingConstraint.constant = 0
            greetingLabel.text = ""
        }
        
        //create PasswordContainerView
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit)
        passwordContainerView.delegate = self
        
        //customize password UI
        passwordContainerView.tintColor = Constants.Colors.brandColor
        passwordContainerView.highlightedColor = Constants.Colors.brandColor
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
        }
    }
}

private extension PinInputViewController {
    func validation(_ input: String) -> Bool {
        return input == "1234"
    }
    
    func validationSuccess() {
        print("*️⃣ success!")
        dismiss(animated: true, completion: nil)
    }
    
    func validationFail() {
        print("*️⃣ failure!")
        passwordContainerView.wrongPassword()
    }
}
