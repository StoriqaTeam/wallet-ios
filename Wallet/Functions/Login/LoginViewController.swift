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
            emailTextField.text = "admin@storiqa.com"
            
            emailTextField.keyboardType = .emailAddress
            emailTextField.returnKeyType = .next
            emailTextField.delegate = self
            emailTextField.validationBlock = {(string) in
                return Validations.isValidEmail(string)
            }
        }
    }
    @IBOutlet private var passwordTextField: StqTextField! {
        didSet {
            //TODO: delete this
            passwordTextField.text = "bqF5BkdsCS"
            
            passwordTextField.isSecureTextEntry = true
            passwordTextField.returnKeyType = .go
            passwordTextField.delegate = self
            passwordTextField.validationBlock = {(string) in
                return !string.isEmpty
            }
        }
    }
    @IBOutlet private var signInButton: StqButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkTextNavigationBar()
        addHideKeyboardGuesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction private func signIn() {
        dismissKeyboard()
        
        if let email = emailTextField.text,
            let password = passwordTextField.text,
            emailTextField.isValid && passwordTextField.isValid {
            print("signIn")
            LoginProvider.shared.delegate = self
            LoginProvider.shared.login(email: email, password: password)
        } else {
            print("emailTextField \(emailTextField.isValid)")
            print("passwordTextField \(passwordTextField.isValid)")
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        print("signUp")
    }
}

extension LoginViewController: StqTextFieldDelegate {
    func textFieldShouldReturn(_ textField: StqTextField) -> Bool {
        if textField == emailTextField {
            textField.endEditing(true)
            _ = passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.endEditing(true)
            signIn()
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
