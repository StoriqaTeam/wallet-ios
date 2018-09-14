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
    typealias Sizes = SizeConstants
    
    class Keys {
        static let kIsFirstLaunch = "isFirstLaunch"
    }
    
    class Errors {
        static let internalApp = "Internal app error"
        static let serverResponse = "Server response error"
        static let unknown = "Unknown error"
        static let userFriendly = "Aliens have stolen some of our servers. Chasing them, but haven’t catch them yet. Please try again or come back later!"
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



