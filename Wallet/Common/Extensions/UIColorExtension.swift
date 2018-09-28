//
//  UIColorExtension.swift
//  Wallet
//
//  Created by Storiqa on 27.08.2018.
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
    @nonobjc class var greyishBrown: UIColor {
        return UIColor(red: 80.0 / 255.0, green: 80.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cloudyBlue: UIColor {
        return UIColor(red: 195.0 / 255.0, green: 206.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var bluegrey: UIColor {
        return UIColor(red: 136.0 / 255.0, green: 158.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
    }
    
    //not from styleguide
    @nonobjc class var lightGray: UIColor {
        return #colorLiteral(red: 0.737254902, green: 0.7333333333, blue: 0.7568627451, alpha: 1) //188 187 193
    }
    @nonobjc class var errorRed: UIColor {
        return #colorLiteral(red: 0.9215686275, green: 0.2705882353, blue: 0.3529411765, alpha: 1) //255 45 85
    }
}
