//
//  UnderlinedTextField.swift
//  Wallet
//
//  Created by Storiqa on 21.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

private enum TextFieldState {
    case error
    case editing
    case idle
}

class UnderlinedTextField: UITextField {
    @IBOutlet var bottomConstraint: NSLayoutConstraint?

    var lineView: UIView!
    private let underlineColor = UIColor.lightGray
    private let focusedColor = Theme.Color.brightSkyBlue
    
    private var messageLabel: UILabel?
    private let messageLabelVerticalMargin: CGFloat = 4
    private let messageLabelHorizontalMargin: CGFloat = 2
    private let errorColor = #colorLiteral(red: 0.9215686275, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
    private var bottomConstraintBackup: CGFloat = 0
    private var textFieldState: TextFieldState = .idle
    
    var layoutBlock: (() -> Void)?
    var hintMessage: String? {
        didSet {
            if let hintMessage = hintMessage {
                textFieldState = .idle
                showMessage(text: hintMessage)
            }
        }
    }
    
    var errorText: String? {
        didSet {
            if errorText != oldValue {
                if let errorText = errorText {
                    textFieldState = .error
                    showMessage(text: errorText)
                } else if let hintMessage = hintMessage {
                    textFieldState = .idle
                    showMessage(text: hintMessage)
                } else {
                    textFieldState = .idle
                    hideError()
                }
            }
        }
    }
    
    override var keyboardType: UIKeyboardType {
        didSet {
            switch keyboardType {
            case .numberPad, .phonePad, .decimalPad, .asciiCapableNumberPad:
                addDoneButtonOnKeyboard()
            default:
                break
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let hintMessage = hintMessage,
            textFieldState == .idle {
            showMessage(text: hintMessage, animated: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineView = underlineView(color: underlineColor)
        backgroundColor = .clear
        font = Theme.Font.generalText
        
        if let bottomConstraint = bottomConstraint {
            bottomConstraintBackup = bottomConstraint.constant
        }
        
        if isSecureTextEntry {
            clearButtonMode = .never
        } else {
            clearButtonMode = .whileEditing
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() else {
            return false
        }
        
        textFieldState = errorText != nil ? .error : .editing
        resolveUnderlineColor()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() else {
            return false
        }
        
        textFieldState = errorText != nil ? .error : .idle
        resolveUnderlineColor()
        return true
    }
}


// MARK: Private methods

extension UnderlinedTextField {
    
    private func showMessage(text: String, animated: Bool = true) {
        let width = self.frame.width - messageLabelHorizontalMargin * 2
        
        if messageLabel == nil {
            messageLabel = UILabel(frame: CGRect(x: messageLabelHorizontalMargin,
                                               y: self.frame.height + messageLabelVerticalMargin,
                                               width: width,
                                               height: 20))
            messageLabel!.font = Theme.Font.errorMessage
            messageLabel!.numberOfLines = 0
            self.addSubview(messageLabel!)
        }
        
        guard let messageLabel = messageLabel else { return }
        
        self.clipsToBounds = false
        
        messageLabel.isHidden = false
        messageLabel.textColor = errorColor
        messageLabel.text = text
        messageLabel.preferredMaxLayoutWidth = width
        messageLabel.sizeToFit()
        
        let height = text.height(withConstrainedWidth: width, font: messageLabel.font)
        let frame = CGRect(origin: messageLabel.frame.origin, size: CGSize(width: width, height: height))
        messageLabel.frame = frame
        
        if let bottomConstraint = bottomConstraint {
            // resize if not enough space
            let delta = height + messageLabelVerticalMargin - bottomConstraintBackup
            if delta > 0 {
                let newValue = bottomConstraintBackup + delta
                
                if newValue != bottomConstraintBackup {
                    bottomConstraint.constant = newValue
                    if animated {
                        animateConstraintChange()
                    } else {
                        layoutBlock?()
                    }
                }
            }
        }
        
        resolveUnderlineColor()
        
        if animated {
            animateMessageLabel()
        }
    }
    
    private func hideError() {
        messageLabel?.isHidden = true
        
        if let bottomConstraint = bottomConstraint {
            bottomConstraint.constant = bottomConstraintBackup
            animateConstraintChange()
        }
        
        resolveUnderlineColor()
        animateMessageLabel()
    }
    
    private func animateConstraintChange() {
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.layoutBlock?()
        })
    }
    
    private func animateMessageLabel() {
        if messageLabel != nil,
            case TextFieldState.error = textFieldState {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.messageLabel?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { _ -> Void in
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.messageLabel?.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    private func resolveUnderlineColor() {
        let height: CGFloat
        
        switch textFieldState {
        case .error:
            lineView.backgroundColor = errorColor
            messageLabel?.textColor = errorColor
            height = 1.5
        case .editing:
            lineView.backgroundColor = focusedColor
            messageLabel?.textColor = underlineColor
            height = 1.5
        case .idle:
            lineView.backgroundColor = underlineColor
            messageLabel?.textColor = underlineColor
            height = Constants.Sizes.lineWidth
        }
        
        if let constraint = lineView.constraints.first(where: { $0.firstAttribute == .height }) {
            constraint.constant = height
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.screenWidth, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        _ = resignFirstResponder()
    }
    
}
