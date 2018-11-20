//
//  UnderlinedTextField.swift
//  Wallet
//
//  Created by Storiqa on 21.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class UnderlinedTextField: UITextField {
    @IBOutlet var bottomConstraint: NSLayoutConstraint? {
        didSet {
            if let bottomConstraint = bottomConstraint {
                bottomConstraintBackup = bottomConstraint.constant
            }
        }
    }

    var lineView: UIView!
    private let underlineColor = UIColor.lightGray
    private let focusedColor = Theme.Color.brightSkyBlue
    
    private var errorLabel: UILabel?
    private let errorLabelVerticalMargin: CGFloat = 4
    private let errorLabelHorizontalMargin: CGFloat = 2
    private let errorColor = #colorLiteral(red: 0.9215686275, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
    private var bottomConstraintBackup: CGFloat = 0
    
    var layoutBlock: (() -> Void)?
    var errorText: String? {
        didSet {
            if errorText != oldValue {
                if errorText != nil {
                    showError()
                } else {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineView = underlineView(color: underlineColor)
        backgroundColor = .clear
        font = Theme.Font.generalText
        
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
        
        resolveUnderlineColor()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        guard super.resignFirstResponder() else {
            return false
        }
        
        resolveUnderlineColor()
        return true
    }
}


// MARK: Private methods

extension UnderlinedTextField {
    
    private func showError() {
        let width = self.frame.width - errorLabelHorizontalMargin * 2
        
        if errorLabel == nil {
            errorLabel = UILabel(frame: CGRect(x: errorLabelHorizontalMargin,
                                               y: self.frame.height + errorLabelVerticalMargin,
                                               width: width,
                                               height: 20))
            errorLabel!.font = Theme.Font.errorMessage
            errorLabel!.numberOfLines = 0
            self.addSubview(errorLabel!)
        }
        
        guard let errorLabel = errorLabel, let errorText = errorText else { return }
        
        self.clipsToBounds = false
        
        errorLabel.isHidden = false
        errorLabel.textColor = errorColor
        errorLabel.text = errorText
        
        let height = errorText.height(withConstrainedWidth: width, font: errorLabel.font)
        let frame = CGRect(origin: errorLabel.frame.origin, size: CGSize(width: errorLabel.frame.width, height: height))
        errorLabel.frame = frame
        
        if let bottomConstraint = bottomConstraint {
            bottomConstraintBackup = bottomConstraint.constant
            
            // resize if not enough space
            let delta = height + errorLabelVerticalMargin - bottomConstraintBackup
            if delta > 0 {
                let newValue = bottomConstraintBackup + delta
                
                if newValue != bottomConstraintBackup {
                    bottomConstraint.constant = newValue
                    animateConstraintChange()
                }
            }
        }
        
        resolveUnderlineColor()
        animateErrorLabel()
    }
    
    private func hideError() {
        errorLabel?.isHidden = true
        
        if let bottomConstraint = bottomConstraint {
            bottomConstraint.constant = bottomConstraintBackup
            animateConstraintChange()
        }
        
        resolveUnderlineColor()
        animateErrorLabel()
    }
    
    private func animateConstraintChange() {
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.layoutBlock?()
        }
    }
    
    private func animateErrorLabel() {
        if errorLabel != nil {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.errorLabel?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { _ -> Void in
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.errorLabel?.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    private func resolveUnderlineColor() {
        let height: CGFloat
        
        if !(errorLabel?.isHidden ?? true) {
            lineView.backgroundColor = errorColor
            height = 1.5
        } else if isFirstResponder {
            lineView.backgroundColor = focusedColor
            height = 1.5
        } else {
            lineView.backgroundColor = underlineColor
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
