//
//  PasswordRecoveryViewController.swift
//  Wallet
//
//  Created by user on 13.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PasswordRecoveryViewController: PasswordRecoveryBaseViewController {
    @IBOutlet private var emailTextField: UnderlinedTextField! {
        didSet {
            emailTextField.placeholder = "Your email"
            emailTextField.layoutBlock = {[weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subtitleLabel.text = "email_for_psw_recovery".localized()
        confirmButton.title = "reset_password".localized()
    }
    
    override func textDidChange(_ notification: Notification) {
        guard let email = emailTextField.text else {
            confirmButton.isEnabled = false
            return
        }
        
        confirmButton.isEnabled = email.isValidEmail()
    }
}

private extension PasswordRecoveryViewController {
    @IBAction func resetPassword(_ sender: UIButton) {
        dismissKeyboard()
        
        guard let email = emailTextField.text else {
            log.error("passwordRecovery error - empty fields")
            return
        }
        
        print("passwordRecovery")
        
        PasswordRecoveryProvider.shared.delegate = self
        PasswordRecoveryProvider.shared.resetPassword(email: email)
    }
}

//MARK: - ProviderDelegate
extension PasswordRecoveryViewController: ProviderDelegate {
    func providerSucceed() {
        //TODO: image, title, text, action
        presentPopup(image: #imageLiteral(resourceName: "faceid"),
                     title: "email_sent".localized(),
                     text: "TODO: text",
            actionTitle: "Ok",
            hasCloseButton: false,
            actionBlock: {[weak self] in
               
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
        
        let kEmail = "email"
        let kGeneral = "general"
        
        for error in errors {
            let key = error.fieldCode == kEmail ? kEmail : kGeneral
            
            if let existingError = errorDict[key] {
                errorDict[key] = existingError + ". " + error.text
            } else {
                errorDict[key] = error.text
            }
        }
        
        if let emailError = errorDict[kEmail] {
            emailTextField.errorText = emailError
        }
        
        if let generalError = errorDict[kGeneral] {
            showAlert(message: generalError)
        }
    }
}

//MARK: - UITextFieldDelegate
extension PasswordRecoveryViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
