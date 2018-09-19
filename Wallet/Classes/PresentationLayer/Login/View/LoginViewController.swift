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
    @IBOutlet private var passwordTextField: UnderlinedTextField!
    @IBOutlet private var signInButton: DefaultButton!
    @IBOutlet private var forgotPasswordButton: UIButton!
    @IBOutlet var socialNetworkAuthView: SocialNetworkAuthView!

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
                                               name: Notification.Name.UITextFieldTextDidChange,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @IBAction private func signIn() {
        dismissKeyboard()
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction private func forgotPasswordTapped() {

    }
    
    @objc func textDidChange(_ notification: Notification) {
        updateContinueButton()
    }
}


// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {

    func setupInitialState() {
        
    }
}


// MARK: - SocialNetworkAuthViewDelegate

extension LoginViewController: SocialNetworkAuthViewDelegate {
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String, email: String) {
        
    }

    func socialNetworkAuthFailed() {
        //TODO: error message
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
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
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
        
        signInButton.title = "get_started".localized()
        forgotPasswordButton.setTitleColor(UIColor.mainBlue, for: .normal)
        forgotPasswordButton.setTitle("forgot_password".localized(), for: .normal)
    }
    
    private func setSocialView() {
        socialNetworkAuthView.setUp(delegate: self, type: .login)
    }

    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}
