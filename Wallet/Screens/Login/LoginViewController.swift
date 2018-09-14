//
//  LoginViewController.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet private var emailTextField: UnderlinedTextField! {
        didSet {
            emailTextField.placeholder = "email".localized()
            emailTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @IBOutlet private var passwordTextField: UnderlinedTextField! {
        didSet {
            passwordTextField.placeholder = "password".localized()
            passwordTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @IBOutlet private var signInButton: DefaultButton! {
        didSet {
            signInButton.title = "get_started".localized()
        }
    }
    @IBOutlet private var forgotPasswordButton: UIButton! {
        didSet {
            forgotPasswordButton.setTitleColor(UIColor.mainBlue, for: .normal)
            forgotPasswordButton.setTitle("forgot_password".localized(), for: .normal)
        }
    }
    @IBOutlet var socialNetworkAuthView: SocialNetworkAuthView! {
        didSet {
            socialNetworkAuthView.setUp(delegate: self, type: .login)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHideKeyboardGuesture()
        updateContinueButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //can be no navigationController here, no fallback
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //can be no navigationController here, no fallback
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Actions
private extension LoginViewController {
    @IBAction private func signIn() {
        dismissKeyboard()
        passwordTextField.isSecureTextEntry = true
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("signIn error - empty fields")
                return
        }
        
        print("signIn")
        
        LoginProvider.shared.delegate = self
        LoginProvider.shared.login(email: email, password: password)
    }
    
    @IBAction private func forgotPasswordTapped() {
        guard let navigationController = navigationController else {
            log.warn("navigationController is nil")
            return
        }
        
        guard let vc = Storyboard.passwordRecovery.viewController(identifier: "PasswordRecoveryVC") else {
            return
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(_ notification: Notification) {
        updateContinueButton()
    }
}

//MARK: - Helpers
private extension LoginViewController {
    func updateContinueButton() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                signInButton.isEnabled = false
                return
        }
        
        signInButton.isEnabled = Validations.isValidEmail(email) && !password.isEmpty
    }
    
    func hideAllErrors() {
        emailTextField.errorText = nil
        passwordTextField.errorText = nil
    }
}

//MARK: - UITextFieldDelegate
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

//MARK: - ProviderDelegate
extension LoginViewController: ProviderDelegate {
    func providerSucceed() {
        //TODO: loginProviderSucceed
        self.showAlert(message: "succeed")
    }
    
    func providerFailedWithMessage(_ message: String) {
        self.showAlert(message: message)
    }
    
    func providerFailedWithApiErrors(_ errors: [ResponseAPIError.Message]) {
        for error in errors {
            switch error.fieldCode {
            case "email":
                emailTextField.errorText = error.text
            case "password":
                passwordTextField.errorText = error.text
            default:
                break
            }
        }
    }
}

//MARK: - SocialNetworkAuthViewDelegate
extension LoginViewController: SocialNetworkAuthViewDelegate {
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String, email: String) {
        LoginProvider.shared.delegate = self
        LoginProvider.shared.login(provider: provider, authToken: token)
    }
    
    func socialNetworkAuthFailed() {
        //TODO: error message
        self.showAlert(message: "socialNetworkAuthFailed")
    }
    
    func socialNetworkAuthViewDidTapFooterButton() {
        guard let navigationController = navigationController else {
            log.warn("navigationController is nil")
            return
        }
        
        if let registerVC = Storyboard.main.viewController(identifier: "RegistrationVC") {
            var vcs = navigationController.viewControllers
            vcs.removeLast()
            vcs.append(registerVC)
            
            navigationController.setViewControllers(vcs, animated: true)
        }
    }
}
