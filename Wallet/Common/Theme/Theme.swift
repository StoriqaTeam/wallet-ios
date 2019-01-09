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
        static let brightOrange = UIColor(red: 241/255, green: 171/255, blue: 59/255, alpha: 1.0)
        static let mainOrange = UIColor(red: 176/255, green: 133/255, blue: 77/255, alpha: 1)
        static let primaryGrey = UIColor(white: 140.0 / 255.0, alpha: 1.0)
        static let backgroundColor = UIColor.black
        static let opaqueWhite = UIColor(white: 1, alpha: 0.5)
        
        struct Button {
            static let enabledTitle = UIColor.white
            static let tintColor = mainOrange
            static let borderGradient = [UIColor(red: 48/255, green: 35/255, blue: 174/255, alpha: 1).cgColor,
                                         UIColor(red: 165/255, green: 120/255, blue: 62/255, alpha: 1).cgColor]
            static let red = UIColor(red: 245/255, green: 81/255, blue: 95/255, alpha: 1)
        }
        
        struct TabBar {
            static let background = UIColor.black
            static let selectedItem = Theme.Color.brightOrange
            static let unselectedItem = UIColor(white: 128/255, alpha: 1)
        }
        
        struct TextField {
            static let input = UIColor.white
            static let placeholder = UIColor(white: 173/255, alpha: 1.0)
            static let underlineColor = UIColor(white: 121/255, alpha: 1.0)
            static let focusedColor = mainOrange
        }
        
        struct SocialAuthView {
            static let separators = UIColor(white: 121/255, alpha: 1.0)
            static let borders = UIColor(white: 49/255, alpha: 1.0)
            static let text = UIColor.white
        }
        
        struct Text {
            static let main = UIColor.white
            static let errorRed = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
            static let lightGrey = UIColor(white: 128.0 / 255.0, alpha: 1.0)
        }
        
        struct NavigationBar {
            static let title = UIColor.white
            static let buttons = UIColor.white
            static let statusBar = UIColor.white
        }
        
        struct Section {
            static let transactionSectionTitle = mainOrange
        }
        
        struct Slider {
            static let track = UIColor(white: 116/255, alpha: 0.52)
        }
        
        struct Notification {
            static let background = UIColor(red: 27/255, green: 26/255, blue: 31/255, alpha: 1)
        }
        
        struct Gradient {
            
            struct Details {
                static let detailBlueGradient = [UIColor(red: 97/255, green: 92/255, blue: 251/255, alpha: 1).cgColor,
                                                 UIColor.clear.cgColor]
                
                static let detailsRedGradient = [UIColor(red: 198/255, green: 86/255, blue: 94/255, alpha: 1).cgColor,
                                                 UIColor.clear.cgColor]
                
            }
            
            static let separator = [UIColor(white: 200/255, alpha: 1).cgColor,
                                             UIColor(white: 1, alpha: 0).cgColor]
            
            static let underlineGradient = [UIColor.white.cgColor,
                                            UIColor.clear.cgColor]
        }
    }
    
    struct Font {
        
        /** 26px regular */
        static let title = MontserratFont.font(ofSize: 26.0, weight: .regular)
        /** 12px regular */
        static let subtitle = MontserratFont.font(ofSize: 12.0, weight: .regular)
        /** 14px medium */
        static let regularMedium = MontserratFont.font(ofSize: 14.0, weight: .medium)
        /** 14px regular */
        static let regular = MontserratFont.font(ofSize: 14, weight: .regular)
        /** 12px regular */
        static let smallText = MontserratFont.font(ofSize: 12.0, weight: .regular)
        /** 12px medium */
        static let smallMediumWeightText = MontserratFont.font(ofSize: 12, weight: .medium)
        /** 12px semibold */
        static let smallBoldText = MontserratFont.font(ofSize: 12, weight: .semibold)
        /** 16 px medium */
        static let input = MontserratFont.font(ofSize: 16, weight: .medium)
        /** 16 px regular */
        static let placeholder = MontserratFont.font(ofSize: 16, weight: .regular)
        /** 26 px medium */
        static let largeText = MontserratFont.font(ofSize: 26, weight: .medium)
        /** 10 px medium */
        static let extraSmallMediumText = MontserratFont.font(ofSize: 10, weight: .medium)
        
        struct Button {
            /** 16px medium */
            static let buttonTitle = MontserratFont.font(ofSize: 16, weight: .medium)
            /** 12px semibold */
            static let smallButtonTitle = MontserratFont.font(ofSize: 12, weight: .semibold)
            /** 10px regular */
            static let extraSmallButtonTitle = MontserratFont.font(ofSize: 10, weight: .regular)
        }
        
        struct PinInput {
            /** 36px light */
            static let number = MontserratFont.font(ofSize: 36.0, weight: .light)
        }
        
        struct PopUp {
            /** 26px medium */
            static let title = MontserratFont.font(ofSize: 26.0, weight: .medium)
            /** 12px regular */
            static let subtitle = MontserratFont.font(ofSize: 12.0, weight: .regular)
            /** 16px medium */
            static let text = MontserratFont.font(ofSize: 16.0, weight: .medium)
            /** 20px medium */
            static let bigText = MontserratFont.font(ofSize: 20.0, weight: .medium)
        }
        
        struct FilterView {
            /** 16px semibold */
            static let filterLabel = MontserratFont.font(ofSize: 16.0, weight: .semibold)
        }
        
        struct SettingsTableView {
            static let cellTitle = MontserratFont.font(ofSize: 16.0, weight: .regular)
        }
        
        struct AccountCards {
            /** 26 px regular */
            static let bigCardAmount = MontserratFont.font(ofSize: 26, weight: .medium)
            /** 22 px regular */
            static let smallCardAmount = MontserratFont.font(ofSize: 22, weight: .medium)
        }
        
        struct NavigationBar {
            /** 16px semibold */
            static let title = MontserratFont.font(ofSize: 16.0, weight: .semibold)
            /** 28px bold */
            static let largeTitle = MontserratFont.font(ofSize: 28.0, weight: .bold)
            
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
