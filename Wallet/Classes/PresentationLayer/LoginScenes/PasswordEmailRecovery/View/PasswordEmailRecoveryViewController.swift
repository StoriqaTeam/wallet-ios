//
//  PasswordEmailRecoveryPasswordEmailRecoveryViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordEmailRecoveryViewController: PasswordRecoveryBaseViewController {

    var output: PasswordEmailRecoveryViewOutput!

    @IBOutlet private var emailTextField: UnderlinedTextField!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func configureInterface() {
        super.configureInterface()
        
        subtitleLabel.text = "email_for_psw_recovery".localized()
        confirmButton.title = "reset_password".localized()
        
        emailTextField.placeholder = "Your email"
        emailTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func resetPassword(_ sender: UIButton) {
        dismissKeyboard()
        
        guard let email = emailTextField.text else {
            log.error("passwordRecovery error - empty fields")
            return
        }
        
        output.resetPassword(email: email)
    }
    
    override func textDidChange(_ notification: Notification) {
        guard let email = emailTextField.text else {
            confirmButton.isEnabled = false
            return
        }
        
        confirmButton.isEnabled = email.isValidEmail()
    }
}


// MARK: - PasswordEmailRecoveryViewInput

extension PasswordEmailRecoveryViewController: PasswordEmailRecoveryViewInput {
    
    func setupInitialState() {

    }

    func setButtonEnabled(_ enabled: Bool) {
        confirmButton.isEnabled = enabled
    }
    
}


// MARK: - UITextFieldDelegate

extension PasswordEmailRecoveryViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
