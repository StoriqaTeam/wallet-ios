//
//  LoginViewController.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet private var emailTextField: UnderlinedTextField! {
        didSet {
            emailTextField.placeholder = "Email"
            emailTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @IBOutlet private var passwordTextField: UnderlinedTextField! {
        didSet {
            passwordTextField.placeholder = "Password"
            passwordTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    @IBOutlet private var signInButton: StqButton! {
        didSet {
            signInButton.title = "Get started"
        }
    }
    @IBOutlet private var forgotPasswordButton: UIButton! {
        didSet {
            forgotPasswordButton.setTitleColor(Constants.Colors.brandColor, for: .normal)
            forgotPasswordButton.setTitle("I forgot password", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkTextNavigationBar()
        addHideKeyboardGuesture()
        updateContinueButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction private func signIn() {
        dismissKeyboard()
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("signIn error - empty fields")
                return
        }
        
        print("signIn")
        
        LoginProvider.shared.delegate = self
        LoginProvider.shared.login(email: email, password: password)
    }
}

private extension LoginViewController {
    @objc func textDidChange(_ notification: Notification) {
        updateContinueButton()
    }
    
    func updateContinueButton() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                signInButton.isEnabled = false
                return
        }
        
        signInButton.isEnabled = Validations.isValidEmail(email) && !password.isEmpty
    }
    
    func hideAllErrors() {
        emailTextField.errorText = nil
        passwordTextField.errorText = nil
    }
    
    func hideErrorForTextField(_ textField: UITextField) {
        (textField as? UnderlinedTextField)?.errorText = nil
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideErrorForTextField(textField)
    }
}

extension LoginViewController: LoginProviderDelegate {
    func loginProviderSucceed() {
        //TODO: loginProviderSucceed
        self.showAlert(message: "succeed")
    }
    
    func loginProviderFailedWithMessage(_ message: String) {
        self.showAlert(message: message)
    }
    
    func loginProviderFailedWithApiErrors(_ errors: [ResponseAPIError.Message]) {
        for error in errors {
            switch error.fieldCode {
            case LoginInput.email.fieldCode:
                emailTextField.errorText = error.text
            case LoginInput.password.fieldCode:
                passwordTextField.errorText = "Password should be between 8 and 30 symbols"
            default:
                break
            }
        }
    }
}
