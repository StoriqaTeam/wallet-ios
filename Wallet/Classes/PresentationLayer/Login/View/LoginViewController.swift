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


    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHideKeyboardGuesture()
        updateContinueButton()
        setDelegates()
        output.viewIsReady()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
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
        output.showPasswordRecovery()
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


//MARK: - ProviderDelegate
extension LoginViewController: ProviderDelegate {
    func providerSucceed() {
        if let _ = UserDefaults.standard.object(forKey: Constants.Keys.kIsQuickLaunchSet) {
            //was set if key has any value
            //TODO: authorized zone

        } else if let quickLaunchVC = Storyboard.quickLaunch.viewController(identifier: "QuickLaunchVC") {
            //TODO: вернуть
//            UserDefaults.standard.set(true, forKey: Constants.Keys.kIsQuickLaunchSet)

            let nvc = UINavigationController(rootViewController: quickLaunchVC)
            present(nvc, animated: true, completion: nil)
        }
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


// MARK: - SocialNetworkAuthViewDelegate

extension LoginViewController: SocialNetworkAuthViewDelegate {
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String, email: String) {
//        LoginProvider.shared.delegate = self
        LoginProvider.shared.login(provider: provider, authToken: token)
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
        
        signInButton.isEnabled = Validations.isValidEmail(email) && !password.isEmpty
    }

    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}
