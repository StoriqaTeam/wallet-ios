//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordRecoveryConfirmViewController: PasswordRecoveryBaseViewController {

    var output: PasswordRecoveryConfirmViewOutput!

    @IBOutlet private var passwordTextField: UnderlinedTextField!
    @IBOutlet private var repeatPasswordTextField: UnderlinedTextField!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
    }
    
    override func configureInterface() {
        super.configureInterface()
        
        let layoutBlock: (() -> Void) = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        subtitleLabel.text = "psw_recovery_confirm_subtitle".localized()
        confirmButton.title = "confirm_new_password".localized()
        
        passwordTextField.placeholder = "password".localized()
        passwordTextField.layoutBlock = layoutBlock
        
        repeatPasswordTextField.placeholder = "repeat_password".localized()
        repeatPasswordTextField.layoutBlock = layoutBlock
    }
    
    // MARK: - Actions
    
    @IBAction private func confirmReset(_ sender: UIButton) {
        dismissKeyboard()
        
        guard let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text,
            password == repeatPassword else {
                log.error("passwordRecovery error - empty fields")
                return
        }
        
        output.confirmReset(newPassword: password)
        
    }
    
    override func textDidChange(_ notification: Notification) {
        output.validateForm(newPassword: passwordTextField.text, passwordConfirm: repeatPasswordTextField.text)
    }
    
}


// MARK: - PasswordRecoveryConfirmViewInput

extension PasswordRecoveryConfirmViewController: PasswordRecoveryConfirmViewInput {
    
    func setupInitialState() {

    }

    func setFormIsValid(_ valid: Bool, passwordsEqualityMessage: String?) {
        confirmButton.isEnabled = valid
        repeatPasswordTextField.errorText = passwordsEqualityMessage
    }
    
    func showErrorMessage(_ password: String?) {
        passwordTextField.errorText = password
    }
    
}


// MARK: - UITextFieldDelegate

extension PasswordRecoveryConfirmViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            repeatPasswordTextField.becomeFirstResponder()
        case repeatPasswordTextField:
            repeatPasswordTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
}
