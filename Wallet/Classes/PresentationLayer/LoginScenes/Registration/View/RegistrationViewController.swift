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
    @IBOutlet private var passwordTextField: SecureInputTextField!
    @IBOutlet private var repeatPasswordTextField: SecureInputTextField!
    @IBOutlet private var agreementTickImageView: UIImageView!
    @IBOutlet private var agreementLabel: UILabel!
    @IBOutlet private var signUpButton: DefaultButton!
    @IBOutlet private var socialNetworkAuthView: SocialNetworkAuthView!
    @IBOutlet private var textFields: [UnderlinedTextField]!
    @IBOutlet private var scrollView: UIScrollView!
    
    // MARK: - Variables
    
    private var activeTextField: UITextField?
    private var isAcceptedAgreement = false
    private let acceptedAgreementColor = Theme.Color.brightSkyBlue
    private let nonAcceptedAgreementColor = UIColor.lightGray
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configFields()
        addHideKeyboardGuesture()
        updateContinueButton()
        setSocialView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
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
        isAcceptedAgreement.toggle()
        setAgreementTintColor()
        updateContinueButton()
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        updateContinueButton()
        
        guard let textField = notification.object as? SecureInputTextField,
            textField.isFirstResponder else {
                return
        }
        
        switch textField {
        case passwordTextField,
             repeatPasswordTextField:
            if passwordTextField.text?.count == repeatPasswordTextField.text?.count {
                output.validatePasswords(onEndEditing: false,
                                         password: passwordTextField.text,
                                         repeatPassword: repeatPasswordTextField.text)
            }
        default:
            break
        }
    }
}


// MARK: - RegistrationViewInput

extension RegistrationViewController: RegistrationViewInput {
    func setupInitialState() {
        addNotificationObservers()
    }
    
    func setSocialView(viewModel: SocialNetworkAuthViewModel) {
        socialNetworkAuthView.bindViewModel(viewModel)
    }
    
    func setButtonEnabled(_ enabled: Bool) {
        signUpButton.isEnabled = enabled
    }
    
    func showErrorMessage(email: String?, password: String?) {
        emailTextField.errorText = email
        passwordTextField.errorText = password
    }
    
    func setPasswordsEqual(_ equal: Bool, message: String?) {
        passwordTextField.markValid(equal)
        repeatPasswordTextField.markValid(equal)
        
        repeatPasswordTextField.errorText = message
    }
}


// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if activeTextField == textField {
            activeTextField = nil
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            _ = lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            _ = emailTextField.becomeFirstResponder()
        case emailTextField:
            _ = passwordTextField.becomeFirstResponder()
        case passwordTextField:
            _ = repeatPasswordTextField.becomeFirstResponder()
        case repeatPasswordTextField:
            _ = repeatPasswordTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != repeatPasswordTextField {
            (textField as? UnderlinedTextField)?.errorText = nil
        }
        
        if textField is SecureInputTextField {
            output.validatePasswords(onEndEditing: true,
                                     password: passwordTextField.text,
                                     repeatPassword: repeatPasswordTextField.text)
        }
    }
}

// MARK: - SocialNetworkAuthViewDelegate

extension RegistrationViewController: SocialNetworkAuthViewDelegate {
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String, email: String) {
        output.socialNetworkRegisterSucceed(provider: provider, token: token, email: email)
    }
    
    func socialNetworkAuthFailed() {
        output.socialNetworkRegisterFailed()
    }
    
    func socialNetworkAuthViewDidTapFooterButton() {
        showSignInViewController()
    }
}


// MARK: - Helpers

extension RegistrationViewController {
    private func configFields() {
        
        let layoutBlock: (() -> Void) = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        firstNameTextField.placeholder = "first_name".localized()
        firstNameTextField.layoutBlock = layoutBlock
        
        lastNameTextField.placeholder = "last_name".localized()
        lastNameTextField.layoutBlock = layoutBlock
        
        emailTextField.placeholder = "email".localized()
        emailTextField.layoutBlock = layoutBlock
        
        passwordTextField.placeholder = "password".localized()
        passwordTextField.hintMessage = "At least: 8 characters, 1 capital, 1 digit, 1 special sign"
        passwordTextField.layoutBlock = layoutBlock
        
        repeatPasswordTextField.placeholder = "repeat_password".localized()
        repeatPasswordTextField.layoutBlock = layoutBlock
        
        setAgreementTintColor()
        
        agreementLabel.textColor = Theme.Color.primaryGrey
        agreementLabel.text = "accept_agreement".localized()
        
        signUpButton.title = "sign_up".localized()
    }
    
    private func updateContinueButton() {
        output.validateFields(firstName: firstNameTextField.text,
                              lastName: lastNameTextField.text,
                              email: emailTextField.text,
                              password: passwordTextField.text,
                              repeatPassword: repeatPasswordTextField.text,
                              agreement: isAcceptedAgreement)
    }
    
    
    private func setAgreementTintColor() {
        agreementTickImageView.image = isAcceptedAgreement ? #imageLiteral(resourceName: "checkOn") : #imageLiteral(resourceName: "checkOff")
    }
    
    private func restoreSecureFields() {
        //hide password just in case
        passwordTextField.hidePassword()
        repeatPasswordTextField.hidePassword()
    }
    
    private func showSignInViewController() {
        output.showLogin()
    }
    
    private func setSocialView() {
        socialNetworkAuthView.setUp(from: self, delegate: self, type: .register)
    }
}


// MARK: Keyboard notifications

extension RegistrationViewController {
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let scrollView = scrollView,
            let activeTextField = activeTextField,
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        let keyboardOrigin = Constants.Sizes.screenHeight - keyboardFrame.cgRectValue.height
        let textFieldOrigin = activeTextField.convert(activeTextField.bounds, to: view).maxY
        var delta = textFieldOrigin - keyboardOrigin + 8
        
        guard delta > 0 else { return }
        
        if scrollView.contentSize.height < view.frame.height {
            delta += view.frame.height - scrollView.contentSize.height
        }
        
        scrollView.contentOffset = CGPoint(x: 0, y: delta)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: delta, right: 0)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let scrollView = scrollView else {
            return
        }
        
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
    }
}
