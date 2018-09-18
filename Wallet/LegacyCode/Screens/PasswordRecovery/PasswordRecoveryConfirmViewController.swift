//
//  PasswordRecoveryConfirmViewController.swift
//  Wallet
//
//  Created by user on 14.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PasswordRecoveryConfirmViewController: PasswordRecoveryBaseViewController {
    @IBOutlet private var passwordTextField: UnderlinedTextField! {
        didSet {
            passwordTextField.placeholder = "password".localized()
            passwordTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    @IBOutlet private var repeatPasswordTextField: UnderlinedTextField! {
        didSet {
            repeatPasswordTextField.placeholder = "repeat_password".localized()
            repeatPasswordTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    var token: String?
    
    static func create(token: String) -> UINavigationController? {
        //должен ли здесь быт fatal
        if let vc = Storyboard.passwordRecovery.viewController(identifier: "PasswordRecoveryConfirmVC") as? PasswordRecoveryConfirmViewController {
            vc.token = token
            
            let nvc = UINavigationController(rootViewController: vc)
            return nvc
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subtitleLabel.text = "psw_recovery_confirm_subtitle".localized()
        confirmButton.title = "confirm_new_password".localized()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"), style: .plain, target: nil, action: #selector(dismissViewController))
    }
    
    override func textDidChange(_ notification: Notification) {
        
        guard let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text else {
            confirmButton.isEnabled = false
            return
        }
        
        var formIsValid = !password.isEmpty && !repeatPassword.isEmpty
        
        if formIsValid {
            if password != repeatPassword {
                //TODO: сообщение
                repeatPasswordTextField.errorText = "passwords_nonequeal".localized()
                formIsValid = false
            } else {
                repeatPasswordTextField.errorText = nil
            }
        }
        
        confirmButton.isEnabled = formIsValid
    }
}

private extension PasswordRecoveryConfirmViewController {
    @IBAction func confirmReset(_ sender: UIButton) {
        dismissKeyboard()
        
        guard let token = token else {
            log.error("passwordRecovery error - empty token")
            return
        }
        
        guard let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text else {
            log.error("passwordRecovery error - empty fields")
            return
        }
        
        guard password == repeatPassword else {
            log.error("passwordRecovery error - paswords do not match")
            return
        }
        
        print("passwordRecovery")
        
        PasswordRecoveryConfirmProvider.shared.delegate = self
        PasswordRecoveryConfirmProvider.shared.confirmReset(token: token, password: password)
    }
}

//MARK: - UITextFieldDelegate
extension PasswordRecoveryConfirmViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            repeatPasswordTextField.becomeFirstResponder()
        case repeatPasswordTextField:
            repeatPasswordTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
}

//MARK: - ProviderDelegate
extension PasswordRecoveryConfirmViewController: ProviderDelegate {
    func providerSucceed() {
        //TODO: image, title, text
        presentPopup(image: #imageLiteral(resourceName: "faceid"),
                     title: "psw_recovery_result_success_title".localized(),
                     text: "psw_recovery_result_success_subtitle".localized(),
            actionTitle: "Sign in",
            hasCloseButton: false,
            actionBlock: {[weak self] in
                self?.dismissViewController()
        })
    }
    
    func providerFailedWithMessage(_ message: String) {
        //TODO: image, title
        
        let text = message == Constants.Errors.unknown ? Constants.Errors.userFriendly : message
        
        presentPopup(image: #imageLiteral(resourceName: "faceid"),
                     title: "smth_went_wrong".localized(),
                     text: text,
                     actionTitle: "try_again".localized(),
                     hasCloseButton: true,
                     actionBlock: {})
    }
    
    func providerFailedWithApiErrors(_ errors: [ResponseAPIError.Message]) {
        var errorDict = [String: String]()
        
        let kPassword = "password"
        let kGeneral = "general"
        
        for error in errors {
            let key = error.fieldCode == kPassword ? kPassword : kGeneral
            
            if let existingError = errorDict[key] {
                errorDict[key] = existingError + ". " + error.text
            } else {
                errorDict[key] = error.text
            }
        }
        
        if let passwordError = errorDict[kPassword] {
            passwordTextField.errorText = passwordError
        }
        
        if let generalError = errorDict[kGeneral] {
            showAlert(message: generalError)
        }
    }
}
