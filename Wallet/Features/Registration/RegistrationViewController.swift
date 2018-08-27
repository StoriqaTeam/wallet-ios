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
    @IBOutlet private var firstNameTextField: UnderlinedTextField! {
        didSet {
            firstNameTextField.placeholder = "First name"
            firstNameTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    @IBOutlet private var lastNameTextField: UnderlinedTextField! {
        didSet {
            lastNameTextField.placeholder = "Last name"
            lastNameTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
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
    @IBOutlet private var repeatPasswordTextField: UnderlinedTextField! {
        didSet {
            repeatPasswordTextField.placeholder = "Repeat password"
            repeatPasswordTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @IBOutlet private var agreementTickImageView: UIImageView! {
        didSet {
            setAgreementTintColor()
        }
    }
    
    @IBOutlet private var agreementLabel: UILabel! {
        didSet {
            agreementLabel.textColor = Constants.Colors.gray
            agreementLabel.text = "I accept the terms of the license agreement and privacy policy"
        }
    }

    @IBOutlet private var signUpButton: DefaultButton! {
        didSet {
            signUpButton.title = "Sign up"
        }
    }
    
    @IBOutlet private var socialNetworkAuthView: SocialNetworkAuthView! {
        didSet {
            socialNetworkAuthView.setUp(delegate: self, type: .register)
        }
    }
    
    @IBOutlet private var textFields: [UnderlinedTextField]!
    @IBOutlet private var stackViewTopSpace: NSLayoutConstraint!
    @IBOutlet private var signInTopSpace: NSLayoutConstraint!
    @IBOutlet private var scrollView: UIScrollView!
    
    private var isAcceptedAgreement = false
    private let acceptedAgreementColor = Constants.Colors.brandColor
    private let nonAcceptedAgreementColor = Constants.Colors.lightGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHideKeyboardGuesture()
        updateContinueButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if scrollView.contentSize.height > 0 {
            let delta = view.frame.height - scrollView.contentSize.height - stackViewTopSpace.constant
            if delta > 0 {
                signInTopSpace.constant = delta
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Actions
private extension RegistrationViewController {
    @IBAction func signUp() {
        dismissKeyboard()
        restoreSecureFields() 
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("signUp error - empty fields")
                return
        }
        
        print("signUp")
        
        RegistrationProvider.shared.delegate = self
        RegistrationProvider.shared.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }
    
    @IBAction func toggleAgreement() {
        isAcceptedAgreement = !isAcceptedAgreement
        setAgreementTintColor()
        updateContinueButton()
    }
    
    @objc func textDidChange(_ notification: Notification) {
        updateContinueButton()
    }
}

//MARK: - Helpers
private extension RegistrationViewController {
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
            default:
                valid = !text.isEmpty
            }
            
            guard valid else {
                formIsValid = false
                break
            }
        }
        
        formIsValid = formIsValid && isAcceptedAgreement
        
        if formIsValid {
            if passwordTextField.text != repeatPasswordTextField.text {
                //TODO: сообщение
                repeatPasswordTextField.errorText = "Passwords are not equeal"
                formIsValid = false
            } else {
                repeatPasswordTextField.errorText = nil
            }
        }
        
        signUpButton.isEnabled = formIsValid
    }
    
    func hideAllErrors() {
        textFields.forEach({ $0.errorText = nil })
    }
    
    
    func hideErrorForTextField(_ textField: UITextField) {
        (textField as? UnderlinedTextField)?.errorText = nil
    }
    
    func setAgreementTintColor() {
        agreementTickImageView.tintColor = isAcceptedAgreement ? acceptedAgreementColor : nonAcceptedAgreementColor
    }
    
    func restoreSecureFields() {
        //hide password just in case
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
    }
}

//MARK: - UITextFieldDelegate
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

//MARK: - RegistrationProviderDelegate
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

//MARK: - SocialNetworkAuthViewDelegate
extension RegistrationViewController: SocialNetworkAuthViewDelegate {
    func socialNetworkAuthViewDidTapFooterButton() {
        if let loginVC = Storyboard.main.viewController(identifier: "LoginVC") {
            self.navigationController?.setViewControllers([loginVC], animated: true)
        } else {
            //TODO: кастомная обработка ошибки
        }
    }
}

