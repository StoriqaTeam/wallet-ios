//
//  StringExtension.swift
//  Wallet
//
//  Created by Storiqa on 21.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//


import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func clearedPhoneNumber() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    func decimalValue() -> Decimal {
        var set = CharacterSet.decimalDigits
        set.insert(charactersIn: ",.")
        let cleared = self.components(separatedBy: set.inverted).joined(separator: "")
        let decimal = cleared.replacingOccurrences(of: ",", with: ".")
        return Decimal(string: decimal) ?? 0
    }
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        //If the string is not found, we show **<key>** for debugging.
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

// MARK: Validations

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return self.matchesReqex(emailRegEx)
    }
    
    func isValidDecimal() -> Bool {
        var number: Decimal?
        
        for formatter in [Decimal.pointFormatter, Decimal.commaFormatter] {
            if let formatted = formatter.number(from: self) {
                number = formatted.decimalValue
                break
            }
        }
        
        return number != nil
    }
    
    func isValidPhone(hasPlusPrefix: Bool, unfinished: Bool = false) -> Bool {
        let trimmed = self.trim()
        
        if trimmed.isEmpty {
            return unfinished
        }
        
        if hasPlusPrefix && !self.hasPrefix("+") {
            return false
        }
        
        let phoneRegEx = "^[\\+]{0,1}[0-9\\- ()]{0,20}$"
        let isAlowedSymbols = trimmed.matchesReqex(phoneRegEx)
        
        if unfinished {
            return isAlowedSymbols
        } else {
            if !isAlowedSymbols {
                return false
            }
            
            let cleared = self.clearedPhoneNumber()
            let minCount = hasPlusPrefix ? 11 : 10
            return cleared.count >= minCount
        }
        
    }
}

private extension String {
    func matchesReqex(_ regex: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let matches = test.evaluate(with: self)
        return matches
    }
}
