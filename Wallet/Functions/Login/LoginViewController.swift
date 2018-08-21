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
            emailTextField.fieldCode = LoginInput.email.fieldCode
        }
    }
    @IBOutlet private var passwordTextField: UnderlinedTextField! {
        didSet {
            passwordTextField.placeholder = "Password"
            passwordTextField.fieldCode = LoginInput.password.fieldCode
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
    }
    
    @IBAction private func signIn() {
        
        dismissKeyboard()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("signIn error - empty fields")
            return
        }
        
        print("signIn")
        
        LoginProvider.shared.delegate = self
        LoginProvider.shared.login(email: email, password: password)
    }
    
    @IBAction func signUp(_ sender: Any) {
        print("signUp")
    }
}

private extension LoginViewController {
    func updateContinueButton(email: String? = nil, password: String? = nil) {
        signInButton.isEnabled = fieldsAreValid(email: email, password: password)
    }
    
    func fieldsAreValid(email: String? = nil, password: String? = nil) ->  Bool {
        guard let email = email ?? emailTextField.text,
            let password = password ?? passwordTextField.text else {
                return false
        }
        
        return Validations.isValidEmail(email) && !password.isEmpty
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //TODO: ограничение на длину полей
        
        guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        if textField == emailTextField {
            updateContinueButton(email: updatedString)
        } else if textField == passwordTextField {
            updateContinueButton(password: updatedString)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateContinueButton()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            updateContinueButton(email: "")
        } else if textField == passwordTextField {
            updateContinueButton(password: "")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        if textField == emailTextField {
            _ = passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            if fieldsAreValid() {
                signIn()
            } else {
                print("invalid fields")
            }
        }
        
        return true
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
            switch error.code {
            case LoginInput.email.fieldCode:
                emailTextField.errorText = error.message
            case LoginInput.password.fieldCode:
                passwordTextField.errorText = error.message
            default:
                break
            }
        }
    }
}
