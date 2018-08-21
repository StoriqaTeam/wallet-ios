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
    private var errorLabel: UILabel?
    private var lineView: UIView?
    private let errorColor = #colorLiteral(red: 0.9215686275, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
    private let underlineColor = Constants.Colors.lightGray
    
    var fieldCode: String?
    var errorText: String? {
        didSet {
            if errorText != nil {
                showError()
            } else {
                hideError()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lineView = underlineView(color: underlineColor)
        backgroundColor = .clear
        font = UIFont.systemFont(ofSize: 17)
    }
    
    private func showError() {
        if errorLabel == nil {
            let font = UIFont.systemFont(ofSize: 12)
            errorLabel = UILabel(frame: CGRect(x: 2, y: self.frame.height + 4, width: self.frame.width - 4, height: font.lineHeight))
            errorLabel!.font = font
            errorLabel?.numberOfLines = 1
        }
        
        lineView?.backgroundColor = errorColor
        self.clipsToBounds = false
        
        if let errorLabel = errorLabel {
            errorLabel.isHidden = false
            errorLabel.textColor = errorColor
            errorLabel.text = errorText
            
            self.addSubview(errorLabel)
            animationLabel()
        }
    }
    
    private func hideError() {
        errorLabel?.isHidden = true
        lineView?.backgroundColor = underlineColor
        animationLabel()
    }
    
    private func animationLabel() {
        if errorLabel != nil {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.errorLabel!.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { (completed) -> Void in
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.errorLabel!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
        }
    }
}
