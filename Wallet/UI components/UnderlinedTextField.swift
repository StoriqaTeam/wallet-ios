//
//  UnderlinedTextField.swift
//  Wallet
//
//  Created by user on 21.08.2018.
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

    var lineView: UIView?
    private let underlineColor = UIColor.lightGray
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineView = underlineView(color: underlineColor)
        backgroundColor = .clear
        font = UIFont.systemFont(ofSize: 17)
        
        if isSecureTextEntry {
            clearButtonMode = .never
        } else {
            clearButtonMode = .whileEditing
        }
    }
    
    private func showError() {
        let width = self.frame.width - errorLabelHorizontalMargin * 2
        
        if errorLabel == nil {
            errorLabel = UILabel(frame: CGRect(x: errorLabelHorizontalMargin, y: self.frame.height + errorLabelVerticalMargin, width: width, height: 20))
            errorLabel!.font = UIFont.systemFont(ofSize: 12)
            errorLabel?.numberOfLines = 0
        }

        lineView?.backgroundColor = errorColor
        self.clipsToBounds = false

        if let errorLabel = errorLabel {
            errorLabel.isHidden = false
            errorLabel.textColor = errorColor
            errorLabel.text = errorText

            if let height = errorText?.height(withConstrainedWidth: width, font: errorLabel.font) {
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
            }

            self.addSubview(errorLabel)
            animationLabel()
        }
    }

    private func hideError() {
        errorLabel?.isHidden = true
        lineView?.backgroundColor = underlineColor

        if let bottomConstraint = bottomConstraint {
            bottomConstraint.constant = bottomConstraintBackup
            animateConstraintChange()
        }

        animationLabel()
    }
    
    private func animateConstraintChange() {
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.layoutBlock?()
        }
    }
    
    private func animationLabel() {

        if errorLabel != nil {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.errorLabel?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (completed) -> Void in
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.errorLabel?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
        }
    }
}
