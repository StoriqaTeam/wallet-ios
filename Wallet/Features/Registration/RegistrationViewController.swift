//
//  RegistrationViewController.swift
//  Wallet
//
//  Created by user on 16.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet var firstNameTextField: UnderlinedTextField! {
        didSet {
            firstNameTextField.placeholder = "First Name"
            firstNameTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    @IBOutlet var lastNameTextField: UnderlinedTextField! {
        didSet {
            lastNameTextField.placeholder = "Last Name"
            lastNameTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    @IBOutlet var emailTextField: UnderlinedTextField! {
        didSet {
            emailTextField.placeholder = "Email"
            emailTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    @IBOutlet var passwordTextField: UnderlinedTextField! {
        didSet {
            passwordTextField.placeholder = "Password"
            passwordTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    //TODO: repeat password
    @IBOutlet var repeatPasswordTextField: UnderlinedTextField! {
        didSet {
            repeatPasswordTextField.placeholder = "Repeat password"
            repeatPasswordTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    @IBOutlet var agreementView: AgreementView! {
        didSet {
            agreementView.text = "I accept the terms of the license agreement and privacy policy"
            agreementView.valueChangedBlock = {[weak self] in
                self?.updateContinueButton()
            }
        }
    }
    @IBOutlet var signUpButton: StqButton! {
        didSet {
            signUpButton.title = "Sign Up"
        }
    }
    
    @IBOutlet var textFields: [UnderlinedTextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
        setDarkTextNavigationBar()
        addHideKeyboardGuesture()
        updateContinueButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func signUp() {
        dismissKeyboard()
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text else {
                print("signUp error - empty fields")
                return
        }
        
        guard password == repeatPassword else {
            //TODO: сообщение
            repeatPasswordTextField.errorText = "Passwords are not equeal"
            return
        }
        
        print("signUp")
        
        RegistrationProvider.shared.delegate = self
        RegistrationProvider.shared.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }
}

private extension RegistrationViewController {
    @objc func textDidChange(_ notification: Notification) {
        updateContinueButton()
    }
    
    func updateContinueButton() {
        var formIsValid = true
        
        for textField in textFields {
            // Validate Text Field
            guard let text = textField.text else {
                formIsValid = false
                break
            }
            
            let valid: Bool
            switch textField {
            case emailTextField:
                valid = Validations.isValidEmail(text)
            case passwordTextField, repeatPasswordTextField:
                valid = !text.isEmpty && passwordTextField.text == repeatPasswordTextField.text
            default:
                valid = !text.isEmpty
            }
            
            guard valid else {
                formIsValid = false
                break
            }
        }
        
        signUpButton.isEnabled = formIsValid && agreementView.checkboxSelected
    }
    
    func hideAllErrors() {
        textFields.forEach({ $0.errorText = nil })
    }
    
    
    func hideErrorForTextField(_ textField: UITextField) {
        (textField as? UnderlinedTextField)?.errorText = nil
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            repeatPasswordTextField.becomeFirstResponder()
        case repeatPasswordTextField:
            repeatPasswordTextField.resignFirstResponder()
            
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideErrorForTextField(textField)
    }
}

extension RegistrationViewController: RegistrationProviderDelegate {
    func registrationProviderSucceed() {
        //TODO: registrationProviderSucceed
        self.showAlert(message: "succeed")
        
    }
    
    func registrationProviderFailedWithMessage(_ message: String) {
        self.showAlert(message: message)
        
    }
    
    func registrationProviderFailedWithApiErrors(_ errors: [ResponseAPIError.Message]) {
        for error in errors {
            switch error.fieldCode {
            case RegistrationInput.firstName.fieldCode:
                firstNameTextField.errorText = error.text
            case RegistrationInput.lastName.fieldCode:
                lastNameTextField.errorText = error.text
            case RegistrationInput.email.fieldCode:
                emailTextField.errorText = error.text
            case RegistrationInput.password.fieldCode:
                passwordTextField.errorText = error.text
            default:
                break
            }
        }
    }
}

