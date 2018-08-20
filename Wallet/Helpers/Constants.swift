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
    static let grayTextColor: UIColor = #colorLiteral(red: 0.2509803922, green: 0.2745098039, blue: 0.3019607843, alpha: 1)
}

class SizeConstants {
    static let screenWith = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let isSmallScreen = screenWith < 350
}
