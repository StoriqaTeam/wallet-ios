//
//  Theme.swift
//  Wallet
//
//  Created by Storiqa on 20.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable nesting

import UIKit


struct Theme {
    
    struct Color {
        static let white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.85)
        static let greyShadow = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 0.30)
        static let brightSkyBlue = UIColor(red: 0/255, green: 178/255, blue: 255/255, alpha: 1)
        static let captionGrey = UIColor(red: 135/255, green: 157/255, blue: 185/255, alpha: 1.0)
        static let greyText = UIColor(red: 219/255, green: 225/255, blue: 234/255, alpha: 1.0)
        static let primaryGrey = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1.0)
    }
    
    struct Button {
        struct Color {
            static let greyBorder = UIColor(red: 135/255, green: 157/255, blue: 185/255, alpha: 0.12)
        }
    }
    
    struct Text {
        struct Color {
            static let red = UIColor(red: 245/255, green: 0/255, blue: 57/255, alpha: 1)
            static let green = UIColor(red: 0/255, green: 188/255, blue: 144/255, alpha: 1)
            static let detailsGreen = UIColor(red: 11/255, green: 231/255, blue: 160/255, alpha: 1)
            static let detailsRed = UIColor(red: 238/255, green: 113/255, blue: 113/255, alpha: 1)
        }
    }
    
    struct Gradient {
        struct Details {
            static let detailsRedGradient = [UIColor(displayP3Red: 240/255, green: 243/255, blue: 246/255, alpha: 0.70).cgColor,
                                             UIColor(displayP3Red: 255/255, green: 233/255, blue: 233/255, alpha: 0.70).cgColor]
            
            static let detailsGreenGradient = [UIColor(displayP3Red: 240/255, green: 243/255, blue: 246/255, alpha: 0.70).cgColor,
                                               UIColor(displayP3Red: 233/255, green: 255/255, blue: 248/255, alpha: 0.70).cgColor]
        }
        static let headerGradient = [UIColor(red: 65/255, green: 183/255, blue: 244/255, alpha: 1).cgColor,
                                     UIColor(red: 45/255, green: 100/255, blue: 194/255, alpha: 1).cgColor]
        static let sendingHeaderGradient = [UIColor(red: 55/255, green: 145/255, blue: 221/255, alpha: 1).cgColor,
                                            UIColor(red: 46/255, green: 103/255, blue: 196/255, alpha: 1).cgColor ]
    }
    
    struct Font {
        
        static let segmentTextFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    
}
