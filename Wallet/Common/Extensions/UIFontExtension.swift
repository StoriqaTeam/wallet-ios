//
//  UIFontExtension.swift
//  Wallet
//
//  Created by Storiqa on 13.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension UIFont {
    /** 28px bold */
    @nonobjc class var supertitle: UIFont {
        return UIFont.boldSystemFont(ofSize: 28)
    }
    
    /** 24px light */
    @nonobjc class var title: UIFont {
        return UIFont.systemFont(ofSize: 24, weight: .light)
    }
    
    /** 13px regular */
    @nonobjc class var subtitle: UIFont {
        return UIFont.systemFont(ofSize: 13)
    }
    
    /** 17px regular */
    @nonobjc class var generalText: UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
    
    /** 13px regular */
    @nonobjc class var smallText: UIFont {
        return UIFont.systemFont(ofSize: 13)
    }
    
    /** 13px regular */
    @nonobjc class var smallMediumWeightText: UIFont {
        return UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    /** 13px regular. Must be uppercase */
    @nonobjc class var caption: UIFont {
        return UIFont.systemFont(ofSize: 13)
    }
}
