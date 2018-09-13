//
//  UIColorExtension.swift
//  Wallet
//
//  Created by user on 27.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension UIColor {
    
    @nonobjc class var primaryGrey: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 140.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var secondaryGrey: UIColor {
        return UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var captionGrey: UIColor {
        return UIColor(red: 135.0 / 255.0, green: 157.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var mainBlue: UIColor {
        return UIColor(red: 0.0, green: 178.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    //not from styleguide
    @nonobjc class var lightGray: UIColor {
        return #colorLiteral(red: 0.737254902, green: 0.7333333333, blue: 0.7568627451, alpha: 1) //188 187 193
    }
}
