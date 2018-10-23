//
//  PasswordRecoveryBaseViewController.swift
//  Wallet
//
//  Created by Storiqa on 14.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PasswordRecoveryBaseViewController: UIViewController {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var confirmButton: DefaultButton!
    @IBOutlet private var resetPasswordButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var headerVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private var subtitleTopSpaceConstraint: NSLayoutConstraint!
    
    private let buttonBottomSpace: CGFloat = Device.model == .iPhoneSE ? 24 : 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHideKeyboardGuesture()
        configureInterface()
        
        confirmButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textDidChange(_ notification: Notification) {
        assertionFailure("method must be overriden in child class")
    }
    
    func configureInterface() {
        titleLabel.text = "password_recovery".localized()
        titleLabel.font = Theme.Font.title
        
        subtitleLabel.font = Theme.Font.subtitle
        subtitleLabel.textColor = Theme.Color.primaryGrey
        
        resetPasswordButtonBottomConstraint.constant = buttonBottomSpace
        if Device.model == .iPhoneSE {
            headerVerticalSpaceConstraint.constant = 16
            subtitleTopSpaceConstraint.constant = 16
        }
    }
}

private extension PasswordRecoveryBaseViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.2
            
            var animationOptions = UIView.AnimationOptions()
            if let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
                animationOptions.insert(UIView.AnimationOptions(rawValue: curve))
            }
            
            resetPasswordButtonBottomConstraint.constant = keyboardHeight + buttonBottomSpace
            
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {[weak self] in
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.2
        
        var animationOptions = UIView.AnimationOptions()
        if let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            animationOptions.insert(UIView.AnimationOptions(rawValue: curve))
        }
        
        resetPasswordButtonBottomConstraint.constant = buttonBottomSpace
        
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {[weak self] in
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension PasswordRecoveryBaseViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? UnderlinedTextField)?.errorText = nil
    }
}
