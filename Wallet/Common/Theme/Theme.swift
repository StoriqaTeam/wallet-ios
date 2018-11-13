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
        static let brightSkyBlue = UIColor(red: 0.0, green: 178.0 / 255.0, blue: 1.0, alpha: 1.0)
        static let cloudyBlue = UIColor(red: 195.0 / 255.0, green: 206.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
        static let greyishBrown = UIColor(white: 80.0 / 255.0, alpha: 1.0)
        static let bluegrey = UIColor(red: 136.0 / 255.0, green: 158.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
        static let primaryGrey = UIColor(white: 140.0 / 255.0, alpha: 1.0)
    }
    
    struct Button {
        struct Color {
            static let enabledTitle = UIColor.white
            static let disabledTitle = Theme.Color.primaryGrey
            static let enabledBackground = Theme.Color.brightSkyBlue
            static let disabledBackground = UIColor(white: 242.0 / 255.0, alpha: 1.0)
            static let red = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        }
    }
    
    struct TabBar {
        struct Color {
            static let background = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.82)
            static let shadow = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 0.30)
        }
    }
    
    struct Text {
        struct Color {
            static let blackMain = UIColor(white: 0.0, alpha: 1.0)
            static let captionGrey = UIColor(red: 135/255, green: 157/255, blue: 185/255, alpha: 1.0)
            static let grey = UIColor(red: 219/255, green: 225/255, blue: 234/255, alpha: 1.0)
            static let detailsGreen = UIColor(red: 11/255, green: 231/255, blue: 160/255, alpha: 1)
            static let detailsRed = UIColor(red: 238/255, green: 113/255, blue: 113/255, alpha: 1)
            static let errorRed = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
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
        /** 17px bold */
        static let segmentTextFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        /** 28px bold */
        static let supertitle = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        /** 24px light */
        static let title = UIFont.systemFont(ofSize: 24.0, weight: .light)
        /** 17px regular */
        static let generalText = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        /** 13px regular. Must be uppercase */
        static let caption = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        /** 13px regular */
        static let subtitle = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        /** 13px regular */
        static let smallText = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        /** 17px semibold */
        static let navigationBarTitle = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        /** 13px medium */
        static let smallMediumWeightText = UIFont.systemFont(ofSize: 13, weight: .medium)
        /** 12px regular */
        static let errorMessage = UIFont.systemFont(ofSize: 12)
    }
    
    
}
