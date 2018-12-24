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
    @IBOutlet private var fieldsContainer: UIView!
    
    private var shouldAnimateApperance = false
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHideKeyboardGuesture()
        updateContinueButton()
        configureControls()
        setDelegates()
        setSocialView()
        output.viewIsReady()
        
        if shouldAnimateApperance {
            hideContent(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
        
        if shouldAnimateApperance {
            shouldAnimateApperance = false
            
            UIView.animate(withDuration: 0.35) {
                self.hideContent(false)
            }
        }
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
    
    func setAnimatedApperance() {
        shouldAnimateApperance = true
    }
    
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
        forgotPasswordButton.titleLabel?.font = Theme.Font.Button.smallButtonTitle
        signInHeaderButton.setTitleColor(Theme.Color.Button.enabledTitle, for: .normal)
        signUpHeaderButton.setTitleColor(Theme.Color.Button.enabledTitle, for: .normal)
        signUpHeaderButton.alpha = 0.7
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
        
        let initialSignInCenter = self.signInHeaderButton.center
        let initialSignUpCenter = self.signUpHeaderButton.center
        let translationX = initialSignUpCenter.x - initialSignInCenter.x
        let translationY = initialSignUpCenter.y - initialSignInCenter.y
   
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.hederButtonUnderliner.alpha = 0
            self.signInHeaderButton.alpha = 0.3
            self.signInHeaderButton.center.x += translationX + 5
            self.signUpHeaderButton.center.x -= translationX - 4
            self.signInHeaderButton.center.y += translationY
            self.signUpHeaderButton.center.y -= translationY
            self.signInHeaderButton.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            self.signUpHeaderButton.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        }

        animator.addAnimations({
            self.signInHeaderButton.transform = CGAffineTransform(scaleX: 0.73, y: 0.73)
            self.signUpHeaderButton.transform = CGAffineTransform(scaleX: 1.38, y: 1.38)
            self.signInHeaderButton.alpha = 0.7
            self.signUpHeaderButton.alpha = 1
            self.hideContent(true)
        }, delayFactor: 0.4)

        animator.addCompletion { (_) in completion() }

        animator.startAnimation()
    }
    
    private func hideContent(_ isHidden: Bool) {
        let alpha: CGFloat = isHidden ? 0 : 1
        
        socialNetworkAuthView.alpha = alpha
        hederButtonUnderliner.alpha = alpha
        fieldsContainer.alpha = alpha
    }
}
