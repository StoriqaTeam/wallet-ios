//
//  SecureInputTextField.swift
//  Wallet
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class SecureInputTextField: UnderlinedTextField {
    @IBOutlet var toggleVisibilityButton: UIButton!
    
    private var isValid: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        toggleVisibilityButton.tintColor = Theme.Color.Button.tintColor
        toggleVisibilityButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }
    
    func hidePassword() {
        if !isSecureTextEntry {
            togglePasswordVisibility()
        }
    }
    
    func markValid(_ valid: Bool) {
        self.isValid = valid
        setButtonImage()
    }
}


// MARK: - Private methods

extension SecureInputTextField {
    @objc private func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        setButtonImage()
        
        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             * continues typing unless we intervene. This is prevented by first
             * deleting the existing text and then recovering the original text. */
            deleteBackward()
            
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
    }
    
    private func setButtonImage() {
        let image: UIImage = {
            if !isSecureTextEntry {
                return #imageLiteral(resourceName: "eyeOpened")
            } else if isValid {
                return #imageLiteral(resourceName: "checkPass")
            } else {
                return #imageLiteral(resourceName: "eyeClosed")
            }
        }()
        
        toggleVisibilityButton.setImage(image, for: .normal)
    }
}
