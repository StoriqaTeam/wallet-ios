//
//  Constants.swift
//  Wallet
//
//  Created by Storiqa on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    typealias Sizes = SizeConstants
    
    class Keys {
        static let kIsFirstLaunch = "isFirstLaunch"
        static let kIsQuickLaunchSet = "isQuickLaunchSet"
    }
    
    class Errors {
        static let serverResponse = "server_response_error".localized()
        static let unknown = "unknown_error".localized()
        static let userFriendly = "user_friendly_error".localized()
    }
}


class SizeConstants {
    static let screenWith = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    
    /** There are some differences in interface for small screens (iPhone4 & iPhone5). We can detect such device by width. */
    static let isSmallScreen = screenWith < 350
    
    /** For separators. Depends on screen scale */
    static let lineWidth = 1.0 / UIScreen.main.scale
}



