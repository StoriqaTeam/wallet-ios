//
//  LoginLoginViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var output: LoginViewOutput!
    
    // MARK: - Outlets
    
    @IBOutlet private var emailTextField: UnderlinedTextField!
    @IBOutlet private var passwordTextField: SecureInputTextField!
    @IBOutlet private var signInButton: DefaultButton!
    @IBOutlet private var forgotPasswordButton: UIButton!
    @IBOutlet private var socialNetworkAuthView: SocialNetworkAuthView!
    
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

    func socialNetworkAuthFailed() {
        //TODO: error message
        // FIXME: msg
        self.showAlert(message: "socialNetworkAuthFailed")
    }

    func socialNetworkAuthViewDidTapFooterButton() {
        output.showRegistration()
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
        emailTextField.placeholder = "email".localized()
        emailTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        passwordTextField.placeholder = "password".localized()
        passwordTextField.layoutBlock = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        
        signInButton.title = "sign_in".localized()
        forgotPasswordButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
        forgotPasswordButton.setTitle("forgot_password".localized(), for: .normal)
    }
    
    private func setSocialView() {
        socialNetworkAuthView.setUp(from: self, delegate: self, type: .login)
    }

    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}
