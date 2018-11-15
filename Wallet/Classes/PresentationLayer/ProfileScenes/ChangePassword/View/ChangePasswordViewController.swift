//
//  ChangePasswordViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ChangePasswordViewController: UIViewController {

    var output: ChangePasswordViewOutput!
    
    // MARK: IBOutlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var currentPassword: SecureInputTextField!
    @IBOutlet var newPassword: SecureInputTextField!
    @IBOutlet var repeatPassword: SecureInputTextField!
    @IBOutlet var changePasswordButton: UIButton!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @IBAction func changePassword() {
        dismissKeyboard()
        restoreSecureFields()
        
        guard let currentPassword = currentPassword.text,
            let newPassword = newPassword.text else {
                log.error("changePassword error - empty fields")
                return
        }
        
        output.changePassword(currentPassword: currentPassword, newPassword: newPassword)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        updateContinueButton()
        
        guard let textField = notification.object as? SecureInputTextField,
            textField.isFirstResponder else {
                return
        }
        
        
        switch textField {
        case newPassword,
             repeatPassword:
            if newPassword.text?.count == repeatPassword.text?.count {
                output.validateNewPassword(onEndEditing: false, newPassword.text, repeatPassword.text)
            }
        default:
            break
        }
    }
    
}


// MARK: - ChangePasswordViewInput

extension ChangePasswordViewController: ChangePasswordViewInput {
    
    func setupInitialState() {
        configFields()
        addHideKeyboardGuesture()
    }

    func setPasswordsEqual(_ equal: Bool, message: String?) {
        newPassword.markValid(equal)
        repeatPassword.markValid(equal)
        
        repeatPassword.errorText = message
    }
    
    func setButtonEnabled(_ enabled: Bool) {
        changePasswordButton.isEnabled = enabled
    }
    
    func showErrorMessage(oldPassword: String?, newPassword: String?) {
        self.currentPassword.errorText = oldPassword
        self.newPassword.errorText = newPassword
    }
    
}


// MARK: - UITextFieldDelegate

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case currentPassword:
            _ = newPassword.becomeFirstResponder()
        case newPassword:
            _ = repeatPassword.becomeFirstResponder()
        case repeatPassword:
            _ = repeatPassword.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != repeatPassword {
            (textField as? UnderlinedTextField)?.errorText = nil
        }
        
        switch textField {
        case newPassword,
             repeatPassword:
            output.validateNewPassword(onEndEditing: true, newPassword.text, repeatPassword.text)
        default:
            break
        }
    }
}

// MARK: - Private methods

extension ChangePasswordViewController {
    private func configFields() {
        
        let layoutBlock: (() -> Void) = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        currentPassword.placeholder = "Current password"
        currentPassword.layoutBlock = layoutBlock
        currentPassword.delegate = self
        newPassword.placeholder = "New password"
        newPassword.layoutBlock = layoutBlock
        newPassword.delegate = self
        repeatPassword.placeholder = "Repeat password"
        repeatPassword.layoutBlock = layoutBlock
        repeatPassword.delegate = self
        
        titleLabel.font = Theme.Font.title
        titleLabel.text = "Change password"
    }
    
    private func updateContinueButton() {
        output.validateFields(currentPassword: currentPassword.text,
                              newPassword: newPassword.text,
                              repeatPassword: repeatPassword.text)
    }
    
    private func restoreSecureFields() {
        //hide password just in case
        currentPassword.hidePassword()
        newPassword.hidePassword()
        repeatPassword.hidePassword()
    }
    
}
