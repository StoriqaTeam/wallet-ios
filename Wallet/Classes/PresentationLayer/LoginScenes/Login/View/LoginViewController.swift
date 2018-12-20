//
//  LoginLoginViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.Login

    var output: LoginViewOutput!
    
    // MARK: - Outlets
    
    @IBOutlet private var emailTextField: UnderlinedTextField!
    @IBOutlet private var passwordTextField: SecureInputTextField!
    @IBOutlet private var signInButton: DefaultButton!
    @IBOutlet private var forgotPasswordButton: BaseButton!
    @IBOutlet private var socialNetworkAuthView: SocialNetworkAuthView!
    @IBOutlet private var signInHeaderButton: UIButton!
    @IBOutlet private var signUpHeaderButton: UIButton!
    @IBOutlet private var hederButtonUnderliner: UIView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHideKeyboardGuesture()
        updateContinueButton()
        configureControls()
        setDelegates()
        setSocialView()
        output.viewIsReady()
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    
    @IBAction private func signIn() {
        dismissKeyboard()
        passwordTextField.hidePassword()
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                log.error("login error - empty fields")
                return
        }
        
        output.signIn(email: email, password: password)
    }
    
    @IBAction private func forgotPasswordTapped() {
        output.showPasswordRecovery()
    }
    
    @IBAction private func registerButtonTapped() {
        output.showRegistration()
    }
    
    @objc func textDidChange(_ notification: Notification) {
        updateContinueButton()
    }
}


// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {
    
    func setupInitialState() { }
    
    func setSocialView(viewModel: SocialNetworkAuthViewModel) {
        socialNetworkAuthView.bindViewModel(viewModel)
    }
    
    func showErrorMessage(email: String?, password: String?) {
        emailTextField.errorText = email
        passwordTextField.errorText = password
    }
}


// MARK: - SocialNetworkAuthViewDelegate

extension LoginViewController: SocialNetworkAuthViewDelegate {
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String, email: String) {
        output.signIn(tokenProvider: provider, token: token, email: email)
    }

    func socialNetworkAuthFailed(provider: SocialNetworkTokenProvider) {
        output.socialNetworkRegisterFailed(tokenProvider: provider)
    }
}


// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            _ = passwordTextField.becomeFirstResponder()
        } else {
            _ = passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? UnderlinedTextField)?.errorText = nil
    }
}


// MARK: Private methods

extension LoginViewController {
    private func updateContinueButton() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                signInButton.isEnabled = false
                return
        }
        
        signInButton.isEnabled = email.isValidEmail() && !password.isEmpty
    }
    
    private func configureControls() {
        emailTextField.placeholder = LocalizedStrings.emailPlaceholder
        emailTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        passwordTextField.placeholder = LocalizedStrings.passwordPlaceholder
        passwordTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        signInButton.title = LocalizedStrings.signInButtonTitle
        signInHeaderButton.setTitle(LocalizedStrings.signInButtonTitle, for: .normal)
        signUpHeaderButton.setTitle(LocalizedStrings.signUpButtonTitle, for: .normal)
        forgotPasswordButton.setTitle(LocalizedStrings.forgotButtonTitle, for: .normal)
        
        signInHeaderButton.setTitleColor(Theme.Button.Color.enabledTitle, for: .normal)
        signUpHeaderButton.setTitleColor(Theme.Color.primaryGrey, for: .normal)
        signInHeaderButton.isUserInteractionEnabled = false
        hederButtonUnderliner.backgroundColor = Theme.Button.Color.enabledBackground
    }
    
    private func setSocialView() {
        socialNetworkAuthView.setUp(from: self, delegate: self, type: .login)
    }

    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}
