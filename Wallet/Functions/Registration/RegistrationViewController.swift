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
        }
    }
    @IBOutlet var lastNameTextField: UnderlinedTextField! {
        didSet {
            lastNameTextField.placeholder = "Last Name"
        }
    }
    @IBOutlet var emailTextField: UnderlinedTextField! {
        didSet {
            emailTextField.placeholder = "Email"
        }
    }
    @IBOutlet var passwordTextField: UnderlinedTextField! {
        didSet {
            passwordTextField.placeholder = "Password"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
        setDarkTextNavigationBar()
        addHideKeyboardGuesture()
        updateContinueButton()
    }
    
    @IBAction func signUp() {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("signUp error - empty fields")
                return
        }
        
        RegistrationProvider.shared.delegate = self
        RegistrationProvider.shared.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }
}

private extension RegistrationViewController {
    func updateContinueButton(firstName: String? = nil, lastName: String? = nil, email: String? = nil, password: String? = nil) {
        signUpButton.isEnabled = fieldsAreValid(firstName: firstName, lastName: lastName, email: email, password: password)
    }
    
    func fieldsAreValid(firstName: String? = nil, lastName: String? = nil, email: String? = nil, password: String? = nil) ->  Bool {
        guard let firstName = firstName ?? firstNameTextField.text,
            let lastName = lastName ?? lastNameTextField.text,
            let email = email ?? emailTextField.text,
            let password = password ?? passwordTextField.text else {
                return false
        }
        
        return !firstName.isEmpty && !lastName.isEmpty && Validations.isValidEmail(email) && !password.isEmpty && agreementView.checkboxSelected
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //TODO: ограничение на длину полей
        //        updateContinueButton()
        guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        if textField == firstNameTextField {
            updateContinueButton(firstName: updatedString)
        } else if textField == lastNameTextField {
            updateContinueButton(lastName: updatedString)
        } else if textField == emailTextField {
            updateContinueButton(email: updatedString)
        } else if textField == passwordTextField {
            updateContinueButton(password: updatedString)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            updateContinueButton(firstName: "")
        } else if textField == lastNameTextField {
            updateContinueButton(lastName: "")
        } else if textField == emailTextField {
            updateContinueButton(email: "")
        } else if textField == passwordTextField {
            updateContinueButton(password: "")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            if fieldsAreValid() {
                signUp()
            } else {
                print("invalid fields")
            }
        }
        
        return true
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
            switch error.code {
            case RegistrationInput.firstName.fieldCode:
                firstNameTextField.errorText = error.message
            case RegistrationInput.lastName.fieldCode:
                lastNameTextField.errorText = error.message
            case RegistrationInput.email.fieldCode:
                emailTextField.errorText = error.message
            case RegistrationInput.password.fieldCode:
                passwordTextField.errorText = error.message
            default:
                break
            }
        }
    }
}

