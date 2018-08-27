//
//  UIColorExtension.swift
//  Wallet
//
//  Created by user on 27.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension UIColor {
    @nonobjc class var blackMainText: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    @nonobjc class var disableButton: UIColor {
        return UIColor(white: 170.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var secondaryTextGrey: UIColor {
        return UIColor(white: 140.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var brightSkyBlue: UIColor {
        return UIColor(red: 0.0, green: 178.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    
    //not from styleguide
    @nonobjc class var lightGray: UIColor {
        return #colorLiteral(red: 0.737254902, green: 0.7333333333, blue: 0.7568627451, alpha: 1) //188 187 193
    }
}
