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
        }
    }

    struct Font {
        static let segmentTextFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    
}
