//
//  RegistrationRegistrationViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class RegistrationViewController: UIViewController {

    var output: RegistrationViewOutput!

    // MARK: - Outlets
    
    @IBOutlet private var firstNameTextField: UnderlinedTextField!
    @IBOutlet private var lastNameTextField: UnderlinedTextField!
    @IBOutlet private var emailTextField: UnderlinedTextField!
    @IBOutlet private var passwordTextField: UnderlinedTextField!
    @IBOutlet private var repeatPasswordTextField: UnderlinedTextField!
    @IBOutlet private var agreementTickImageView: UIImageView!
    @IBOutlet private var agreementLabel: UILabel!
    @IBOutlet private var signUpButton: DefaultButton!
    @IBOutlet private var socialNetworkAuthView: SocialNetworkAuthView!
    @IBOutlet private var textFields: [UnderlinedTextField]!
    @IBOutlet private var stackViewTopSpace: NSLayoutConstraint!
    @IBOutlet private var signInTopSpace: NSLayoutConstraint!
    @IBOutlet private var scrollView: UIScrollView!
    
    // MARK: - Variables
    
    private var isAcceptedAgreement = false
    private let acceptedAgreementColor = UIColor.mainBlue
    private let nonAcceptedAgreementColor = UIColor.lightGray

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configFields()
        addHideKeyboardGuesture()
        updateContinueButton()
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Actions

    @IBAction private func signUp() {
        dismissKeyboard()
        restoreSecureFields()
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                log.error("signUp error - empty fields")
                return
        }
        
        log.debug("signUp")
        
        output.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }
    
    @IBAction private func toggleAgreement() {
        isAcceptedAgreement = !isAcceptedAgreement
        setAgreementTintColor()
        updateContinueButton()
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        updateContinueButton()
    }
}


// MARK: - RegistrationViewInput

extension RegistrationViewController: RegistrationViewInput {
    func setupInitialState() { }

    func showSuccess(email: String) {
        showRegisterSuccess(email: email)
    }
    
    func showError(message: String) {
        showError(message: message)
    }
    
    func showApiErrors(_ apiErrors: [ResponseAPIError.Message]) {
        for error in apiErrors {
            switch error.fieldCode {
            case "firstName":
                firstNameTextField.errorText = error.text
            case "lastName":
                lastNameTextField.errorText = error.text
            case "email":
                emailTextField.errorText = error.text
            case "password":
                passwordTextField.errorText = error.text
            default:
                break
            }
        }
    }
    
    func setButtonEnabled(_ enabled: Bool) {
        signUpButton.isEnabled = enabled
    }
    
    func showPasswordsNotEqual(message: String?) {
        repeatPasswordTextField.errorText = message
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
        (textField as? UnderlinedTextField)?.errorText = nil
    }
}

//MARK: - SocialNetworkAuthViewDelegate

extension RegistrationViewController: SocialNetworkAuthViewDelegate {
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String, email: String) {
        showRegisterSuccess(email: email)
    }
    
    func socialNetworkAuthFailed() {
        //TODO: текст
        showRegisterError(Constants.Errors.userFriendly)
    }
    
    func socialNetworkAuthViewDidTapFooterButton() {
        showSignInViewController()
    }
}


//MARK: - Helpers

extension RegistrationViewController {
    private func configFields() {
    
        firstNameTextField.placeholder = "first_name".localized()
        firstNameTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        lastNameTextField.placeholder = "last_name".localized()
        lastNameTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        emailTextField.placeholder = "email".localized()
        emailTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        passwordTextField.placeholder = "password".localized()
        passwordTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        repeatPasswordTextField.placeholder = "repeat_password".localized()
        repeatPasswordTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        setAgreementTintColor()
        
        agreementLabel.textColor = UIColor.secondaryGrey
        agreementLabel.text = "accept_agreement".localized()

        signUpButton.title = "sign_up".localized()
        socialNetworkAuthView.setUp(delegate: self, type: .register)
    }
    
    private func updateContinueButton() {
        output.validateFields(firstName: firstNameTextField.text,
                              lastName: lastNameTextField.text,
                              email: emailTextField.text,
                              password: passwordTextField.text,
                              repeatPassword: repeatPasswordTextField.text,
                              agreement: isAcceptedAgreement)
    }
    
    private func hideAllErrors() {
        textFields.forEach({ $0.errorText = nil })
    }
    
    
    private func setAgreementTintColor() {
        agreementTickImageView.tintColor = isAcceptedAgreement ? acceptedAgreementColor : nonAcceptedAgreementColor
    }
    
    private func restoreSecureFields() {
        //hide password just in case
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
    }
    
    private func showRegisterSuccess(email: String) {
        //TODO: image
        presentPopup(image: #imageLiteral(resourceName: "faceid"),
                     title: "email_sent".localized(),
                     text: "check_email".localized() + email,
                     actionTitle: "sign_in".localized(),
                     hasCloseButton: false,
                     actionBlock: {[weak self] in
                        self?.showSignInViewController()
        })
    }
    
    private func showRegisterError(_ message: String) {
        //TODO: image, action
        presentPopup(image: #imageLiteral(resourceName: "faceid"),
                     title: "smth_went_wrong".localized(),
                     text: message,
                     actionTitle: "try_again".localized(),
                     hasCloseButton: true,
                     actionBlock: {
                        print("button tapped")
        })
    }
    
    private func showSignInViewController() {
        output.showLogin()
    }
}
