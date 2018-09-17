//
//  UITextFieldExtension.swift
//  Wallet
//
//  Created by user on 22.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        isSecureTextEntry = !isSecureTextEntry
        sender.setImage((isSecureTextEntry ? #imageLiteral(resourceName: "eyeClosed") : #imageLiteral(resourceName: "eyeOpened")), for: .normal)
        
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
}
