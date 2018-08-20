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
    @IBOutlet var firstNameTextField: StqTextField! {
        didSet {
            firstNameTextField.delegate = self
            firstNameTextField.placeholder = "First Name"
        }
    }
    @IBOutlet var lastNameTextField: StqTextField! {
        didSet {
            lastNameTextField.delegate = self
            lastNameTextField.placeholder = "Last Name"
        }
    }
    @IBOutlet var emailTextField: StqTextField! {
        didSet {
            emailTextField.keyboardType = .emailAddress
            emailTextField.delegate = self
            emailTextField.placeholder = "Email"
        }
    }
    @IBOutlet var passwordTextField: StqTextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
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
    
    @IBAction func signUp(_ sender: Any) {
        RegistrationProvider.shared.delegate = self
        RegistrationProvider.shared.register(firstName: firstNameTextField.text, lastName: lastNameTextField.text, email: emailTextField.text, password: passwordTextField.text)
    }
}

private extension RegistrationViewController {
    func updateContinueButton(firstName: String? = nil, lastName: String? = nil, email: String? = nil, password: String? = nil) {
        signUpButton.isEnabled = fialdsAreValid(firstName: firstName, lastName: lastName, email: email, password: password)
    }
    
    func fialdsAreValid(firstName: String? = nil, lastName: String? = nil, email: String? = nil, password: String? = nil) ->  Bool {
        let firstName = firstName ?? firstNameTextField.text
        let lastName = lastName ?? lastNameTextField.text
        let email = email ?? emailTextField.text
        let password = password ?? passwordTextField.text
        
        return !firstName.isEmpty && !lastName.isEmpty && Validations.isValidEmail(email) && !password.isEmpty && agreementView.checkboxSelected
    }
}

extension RegistrationViewController: StqTextFieldDelegate {
    func textField(_ textField: StqTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
    
    func textFieldShouldClear(_ textField: StqTextField) -> Bool {
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
    
    func textFieldShouldReturn(_ textField: StqTextField) -> Bool {
        //TODO: переход на след поле
        
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

    func registrationProviderFailedWithErrors(_ errors: [ResponseError]) {
        //TODO: registrationProviderFailedWithErrors
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

