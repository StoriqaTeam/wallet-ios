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
        static let brightOrange = UIColor(red: 200/255, green: 141/255, blue: 49/255, alpha: 1.0)
        static let brightSkyBlue = UIColor(red: 0.0, green: 178.0 / 255.0, blue: 1.0, alpha: 1.0)
        static let cloudyBlue = UIColor(red: 195.0 / 255.0, green: 206.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
        static let greyishBrown = UIColor(white: 80.0 / 255.0, alpha: 1.0)
        static let bluegrey = UIColor(red: 136.0 / 255.0, green: 158.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
        static let primaryGrey = UIColor(white: 140.0 / 255.0, alpha: 1.0)
        static let backgroundColor = UIColor.black
        
        struct Button {
            static let enabledTitle = UIColor.white
            static let disabledTitle = enabledTitle.withAlphaComponent(0.35)
            static let enabledBackground = UIColor(red: 165/255, green: 120/255, blue: 62/255, alpha: 1)
            static let disabledBackground = UIColor(red: 83/255, green: 60/255, blue: 31/255, alpha: 1)
            static let border = UIColor(red: 255/255, green: 180/255, blue: 62/255, alpha: 0.4)
            static let red = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        }
        
        struct TabBar {
            static let background = UIColor.black
            static let selectedItem = Theme.Color.brightOrange
            static let unselectedItem = UIColor(white: 128/255, alpha: 1)
        }
        
        struct TextField {
            static let input = UIColor.white
            static let placeholder = UIColor(white: 175/255, alpha: 1.0)
            static let underlineColor = UIColor(white: 121/255, alpha: 1.0)
            static let focusedColor = UIColor(red: 175/255, green: 133/255, blue: 77/255, alpha: 1.0)
        }
        
        struct SocialAuthView {
            static let separators = UIColor(white: 121/255, alpha: 1.0)
            static let borders = UIColor(white: 49/255, alpha: 1.0)
            static let text = UIColor.white
        }
        
        struct Text {
            static let main = UIColor.white
            static let blackMain = UIColor(white: 0.0, alpha: 1.0)
            static let captionGrey = UIColor(red: 135/255, green: 157/255, blue: 185/255, alpha: 1.0)
            static let grey = UIColor(red: 219/255, green: 225/255, blue: 234/255, alpha: 1.0)
            static let detailsGreen = UIColor(red: 11/255, green: 231/255, blue: 160/255, alpha: 1)
            static let detailsRed = UIColor(red: 238/255, green: 113/255, blue: 113/255, alpha: 1)
            static let errorRed = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
            static let lightGrey = UIColor(white: 191.0 / 255.0, alpha: 1.0)
        }
        
        struct NavigationBar {
            static let title = UIColor.white
            static let buttons = UIColor.white
        }
        
        struct Section {
            static let transactionSectionTitle = UIColor(red: 165/255, green: 120/255, blue: 62/255, alpha: 1)
        }
        
        struct Gradient {
            struct Details {
                static let detailsRedGradient = [UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 0.43).cgColor,
                                                 UIColor(red: 234/255, green: 237/255, blue: 241/255, alpha: 0.43).cgColor]
                
                static let detailsGreenGradient = [UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 0.43).cgColor,
                                                   UIColor(red: 234/255, green: 237/255, blue: 241/255, alpha: 0.43).cgColor]
            }
            
            static let headerGradient = [UIColor(red: 65/255, green: 183/255, blue: 244/255, alpha: 1).cgColor,
                                         UIColor(red: 45/255, green: 100/255, blue: 194/255, alpha: 1).cgColor]
            
            static let sendingHeaderGradient = [UIColor(red: 55/255, green: 145/255, blue: 221/255, alpha: 1).cgColor,
                                                UIColor(red: 46/255, green: 103/255, blue: 196/255, alpha: 1).cgColor]
        }
    }
    
    struct Font {
        
        /** 17px bold */
        static let segmentTextFont = MontserratFont.font(ofSize: 17, weight: .bold)
        /** 28px bold */
        static let supertitle = MontserratFont.font(ofSize: 28.0, weight: .bold)
        /** 26px regular */
        static let title = MontserratFont.font(ofSize: 26.0, weight: .regular)
        /** 17px regular */
        static let generalText = MontserratFont.font(ofSize: 17.0, weight: .regular)
        /** 13px regular. Must be uppercase */
        static let caption = MontserratFont.font(ofSize: 13.0, weight: .regular)
        /** 13px regular */
        static let subtitle = MontserratFont.font(ofSize: 13.0, weight: .regular)
        /** 13px regular */
        static let smallText = MontserratFont.font(ofSize: 13.0, weight: .regular)
        /** 16px semibold */
        static let navigationBarTitle = MontserratFont.font(ofSize: 16.0, weight: .semibold)
        /** 28px bold */
        static let largeNavigationBarTitle = MontserratFont.font(ofSize: 28.0, weight: .bold)
        /** 12px medium */
        static let smallMediumWeightText = MontserratFont.font(ofSize: 12, weight: .medium)
        /** 12px semibold */
        static let smallBoldText = MontserratFont.font(ofSize: 12, weight: .semibold)
        /** 12px regular */
        static let errorMessage = MontserratFont.font(ofSize: 12, weight: .regular)
        /** 16 px regular */
        static let input = MontserratFont.font(ofSize: 16, weight: .regular)
        /** 26 px regular */
        static let largeText = MontserratFont.font(ofSize: 26, weight: .medium)
        
        struct Button {
            /** 16px medium */
            static let buttonTitle = MontserratFont.font(ofSize: 16, weight: .medium)
            /** 12px medium */
            static let smallButtonTitle = MontserratFont.font(ofSize: 12, weight: .medium)
            /** 10px regular */
            static let extraSmallButtonTitle = MontserratFont.font(ofSize: 10, weight: .regular)
        }
        
        struct PinInput {
            /** 36px light */
            static let number = MontserratFont.font(ofSize: 36.0, weight: .light)
        }
        
        struct Label {
            static let medium = MontserratFont.font(ofSize: 14.0, weight: .medium)
        }
        
    }
}


private struct MontserratFont {
    
    static let fontFamily = "Montserrat-"
    
    static func font(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont? {
        switch weight {
        case .ultraLight:
            return UIFont(name: fontFamily+"ExtraLight", size: ofSize)
        case .thin:
            return UIFont(name: fontFamily+"Thin", size: ofSize)
        case .light:
            return UIFont(name: fontFamily+"Light", size: ofSize)
        case .regular:
            return UIFont(name: fontFamily+"Regular", size: ofSize)
        case .medium:
            return UIFont(name: fontFamily+"Medium", size: ofSize)
        case .semibold:
            return UIFont(name: fontFamily+"SemiBold", size: ofSize)
        case .bold:
            return UIFont(name: fontFamily+"SemiBold", size: ofSize)
        case .heavy:
            return UIFont(name: fontFamily+"ExtraBold", size: ofSize)
        case .black:
            return UIFont(name: fontFamily+"ExtraBold", size: ofSize)
        default:
            return UIFont(name: fontFamily+"Black", size: ofSize)
        }
    }
}
