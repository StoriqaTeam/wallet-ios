//
//  Constants.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    typealias Colors = ColorConstants
    typealias Sizes = SizeConstants
}

class ColorConstants {
    static let brandColor: UIColor = #colorLiteral(red: 0.1607843137, green: 0.6980392157, blue: 0.9921568627, alpha: 1)
    static let darkGray: UIColor = #colorLiteral(red: 0.2509803922, green: 0.2745098039, blue: 0.3019607843, alpha: 1) //64 70 77
    static let gray: UIColor = #colorLiteral(red: 0.5490196078, green: 0.5490196078, blue: 0.5490196078, alpha: 1) //140 140 140
    static let lightGray: UIColor = #colorLiteral(red: 0.737254902, green: 0.7333333333, blue: 0.7568627451, alpha: 1) //188 187 193
}

class SizeConstants {
    static let screenWith = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let isSmallScreen = screenWith < 350
    static let lineWidth = 1.0 / UIScreen.main.scale
}
