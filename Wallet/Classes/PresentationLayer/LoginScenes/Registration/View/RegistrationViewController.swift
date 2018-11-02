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
    
    // FIXME: SocialNetworkAuthView hidden before release: return height to 175 !!!!!
    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
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
    func setupInitialState() { }
    
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
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String) {
        output.socialNetworkRegisterSucceed()
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
