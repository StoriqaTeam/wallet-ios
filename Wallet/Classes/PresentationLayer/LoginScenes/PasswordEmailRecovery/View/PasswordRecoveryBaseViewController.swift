//
//  PasswordRecoveryBaseViewController.swift
//  Wallet
//
//  Created by Storiqa on 14.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PasswordRecoveryBaseViewController: UIViewController {
    
    typealias LocalizedString = Strings.PasswordRecovery
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var confirmButton: DefaultButton!
    @IBOutlet private var resetPasswordButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var headerVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet private var subtitleTopSpaceConstraint: NSLayoutConstraint!
    
    var keyboardAnimationEnabled = true
    private let buttonBottomSpace: CGFloat = Device.model == .iPhoneSE ? 24 : 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHideKeyboardGuesture()
        configureInterface()
        addNotificationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textDidChange(_ notification: Notification) {
        assertionFailure("method must be overriden in child class")
    }
    
    func configureInterface() {
        view.backgroundColor = Theme.Color.backgroundColor
        
        titleLabel.text = LocalizedString.screenTitle
        titleLabel.font = Theme.Font.title
        subtitleLabel.font = Theme.Font.subtitle
        titleLabel.textColor = Theme.Color.Text.main
        subtitleLabel.textColor = Theme.Color.opaqueWhite
        
        resetPasswordButtonBottomConstraint.constant = buttonBottomSpace
        if Device.model == .iPhoneSE {
            headerVerticalSpaceConstraint.constant = 16
            subtitleTopSpaceConstraint.constant = 16
        }
        confirmButton.isEnabled = false
    }
}

extension PasswordRecoveryBaseViewController {
    
    private func addNotificationObservers() {
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard keyboardAnimationEnabled,
            let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let safeAreaBottom = AppDelegate.currentWindow.safeAreaInsets.bottom
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.2
        
        var animationOptions = UIView.AnimationOptions()
        if let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            animationOptions.insert(UIView.AnimationOptions(rawValue: curve))
        }
        
        resetPasswordButtonBottomConstraint.constant = keyboardHeight + buttonBottomSpace - safeAreaBottom
        
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {[weak self] in
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard keyboardAnimationEnabled else {
            return
        }
        
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
