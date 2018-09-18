//
//  Validations.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class Validations {
    class func isValidEmail(_ string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return string.matchesReqex(emailRegEx)
    }
}

private extension String {
    func matchesReqex(_ regex: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let matches = test.evaluate(with: self)
        return matches
    }
}

