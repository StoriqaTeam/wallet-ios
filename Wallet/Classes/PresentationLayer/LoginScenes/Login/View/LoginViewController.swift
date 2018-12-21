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
    @IBOutlet private var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private var headerView: UIView!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
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
        swapButtonsFront(duration: 0.5) {
            self.output.showRegistration()
        }
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
        
        signInHeaderButton.setTitleColor(Theme.Color.Button.enabledTitle, for: .normal)
        signUpHeaderButton.setTitleColor(Theme.Color.primaryGrey, for: .normal)
        signInHeaderButton.isUserInteractionEnabled = false
        hederButtonUnderliner.backgroundColor = Theme.Color.Button.enabledBackground
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        topSpaceConstraint.constant = statusBarHeight * 2
    }
    
    private func setSocialView() {
        socialNetworkAuthView.setUp(from: self, delegate: self, type: .login)
    }

    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func swapButtonsFront(duration: Double, completion: @escaping () -> Void) {
        
        let initialSignInCenter = self.signInHeaderButton.center.x
        let initialSignUpCenter = self.signUpHeaderButton.center.x
        let translation = initialSignUpCenter - initialSignInCenter
        
        UIView.animate(withDuration: duration/2,
                       animations: {
                        self.signInHeaderButton.center.x += translation/2
                        self.signUpHeaderButton.center.x -= translation/2
                        self.signInHeaderButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        self.signUpHeaderButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                        self.hederButtonUnderliner.alpha = 0
                        self.signUpHeaderButton.alpha = 0.5
        }, completion: { (_) in
            UIView.animate(withDuration: duration/2,
                           animations: {
                            self.signInHeaderButton.center.x += translation/2 + 5
                            self.signUpHeaderButton.center.x -= translation/2 - 4
                            self.signInHeaderButton.transform = CGAffineTransform(scaleX: 0.73, y: 0.73)
                            self.signUpHeaderButton.transform = CGAffineTransform(scaleX: 1.38, y: 1.38)
                            self.signUpHeaderButton.alpha = 1.0
                            self.hideContent(true)
            }, completion: { (_) in
                self.signUpHeaderButton.titleLabel?.textColor = .white
                self.signInHeaderButton.titleLabel?.textColor = .lightGray
                let oldFrame = self.hederButtonUnderliner.frame
                self.hederButtonUnderliner.frame = CGRect(x: oldFrame.origin.x,
                                                          y: oldFrame.origin.y,
                                                          width: self.signUpHeaderButton.frame.width,
                                                          height: oldFrame.height)
                UIView.animate(withDuration: 0.3, animations: {
                    self.self.hederButtonUnderliner.alpha = 1.0
                })
                
                completion()
            })
        })
    }
    
    private func hideContent(_ isHidden: Bool) {
        let alpha: CGFloat = isHidden ? 0 : 1
        
        self.emailTextField.alpha = alpha
        self.passwordTextField.alpha = alpha
        self.forgotPasswordButton.alpha = alpha
        self.socialNetworkAuthView.alpha = alpha
        self.hederButtonUnderliner.alpha = alpha
        self.signInButton.alpha = alpha
    }
}
