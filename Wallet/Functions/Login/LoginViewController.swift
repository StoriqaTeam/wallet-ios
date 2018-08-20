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
    @IBOutlet private var emailTextField: StqTextField! {
        didSet {
            //TODO: delete this
//            emailTextField.text = "admin@storiqa.com"
            
            emailTextField.keyboardType = .emailAddress
            emailTextField.returnKeyType = .next
            emailTextField.delegate = self
        }
    }
    @IBOutlet private var passwordTextField: StqTextField! {
        didSet {
            //TODO: delete this
//            passwordTextField.text = "bqF5BkdsCS"
            
            passwordTextField.isSecureTextEntry = true
            passwordTextField.returnKeyType = .go
            passwordTextField.delegate = self
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
        print("signIn")
        
        dismissKeyboard()
        LoginProvider.shared.delegate = self
        LoginProvider.shared.login(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func signUp(_ sender: Any) {
        print("signUp")
    }
}

private extension LoginViewController {
    func updateContinueButton(email: String? = nil, password: String? = nil) {
        signInButton.isEnabled = fialdsAreValid(email: email, password: password)
    }
    
    func fialdsAreValid(email: String? = nil, password: String? = nil) ->  Bool {
        let email = email ?? emailTextField.text
        let password = password ?? passwordTextField.text
        
        return Validations.isValidEmail(email) && !password.isEmpty
    }
}

extension LoginViewController: StqTextFieldDelegate {
    func textField(_ textField: StqTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //TODO: ограничение на длину полей
        //        updateContinueButton()
        guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        if textField == emailTextField {
            updateContinueButton(email: updatedString)
        } else if textField == passwordTextField {
            updateContinueButton(password: updatedString)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: StqTextField) {
        updateContinueButton()
    }
    
    func textFieldShouldClear(_ textField: StqTextField) -> Bool {
        if textField == emailTextField {
            updateContinueButton(email: "")
        } else if textField == passwordTextField {
            updateContinueButton(password: "")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: StqTextField) -> Bool {
        if textField == emailTextField {
            textField.endEditing(true)
            _ = passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.endEditing(true)
            
            if fialdsAreValid() {
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
    
    func loginProviderFailedWithErrors(_ errors: [ResponseError]) {
        //TODO: loginProviderFailedWithErrors
        let desc = errors.map({ (error) -> String in
            if let error = error as? ResponseAPIError {
                return error.message?.description ?? ""
            } else if let error = error as? ResponseDefaultError {
                return error.details
            }
            return ""
        })
        
        self.showAlert(message: desc.description)
    }
}
