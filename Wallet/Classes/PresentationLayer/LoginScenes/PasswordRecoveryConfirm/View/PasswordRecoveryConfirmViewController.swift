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

    @IBOutlet private var passwordTextField: SecureInputTextField!
    @IBOutlet private var repeatPasswordTextField: SecureInputTextField!

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
        
        subtitleLabel.text = LocalizedString.passwordInputScreenSubtitle
        confirmButton.title = LocalizedString.passwordInputScreenConfirmButton
        
        passwordTextField.placeholder = LocalizedString.passwordFieldPlaceholder
        passwordTextField.hintMessage = LocalizedString.passwordFieldHint
        passwordTextField.layoutBlock = layoutBlock
        
        repeatPasswordTextField.placeholder = LocalizedString.repeatPasswordFieldPlaceholder
        repeatPasswordTextField.layoutBlock = layoutBlock
        
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
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
        let equalLength = passwordTextField.text?.count == repeatPasswordTextField.text?.count
        output.validateForm(withMessage: equalLength,
                            newPassword: passwordTextField.text,
                            passwordConfirm: repeatPasswordTextField.text)
    }
    
}


// MARK: - PasswordRecoveryConfirmViewInput

extension PasswordRecoveryConfirmViewController: PasswordRecoveryConfirmViewInput {
    
    func setupInitialState() {

    }

    func setFormIsValid(_ valid: Bool, passwordsEqualityMessage: String?) {
        confirmButton.isEnabled = valid
        repeatPasswordTextField.errorText = passwordsEqualityMessage
        passwordTextField.markValid(valid)
        repeatPasswordTextField.markValid(valid)
    }
    
    func showErrorMessage(_ password: String?) {
        passwordTextField.errorText = password
    }
    
}


// MARK: - UITextFieldDelegate

extension PasswordRecoveryConfirmViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case passwordTextField:
            keyboardAnimationEnabled = false
            _ = repeatPasswordTextField.becomeFirstResponder()
            keyboardAnimationEnabled = true
        case repeatPasswordTextField:
            _ = repeatPasswordTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            (textField as? UnderlinedTextField)?.errorText = nil
        }
        
        output.validateForm(withMessage: true,
                            newPassword: passwordTextField.text,
                            passwordConfirm: repeatPasswordTextField.text)
    }
}
