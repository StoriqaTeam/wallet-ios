//
//  Constants.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit
import Slog

let log = Slog(level: .debug, useEmoji: true)


struct Constants {
    typealias Sizes = SizeConstants
    
    struct Keys {
        static let kIsFirstLaunch = "isFirstLaunch"
        static let kIsQuickLaunchSet = "isQuickLaunchSet"
    }
    
    struct Errors {
        static let serverResponse = "server_response_error".localized()
        static let unknown = "unknown_error".localized()
        static let userFriendly = "user_friendly_error".localized()
    }
    
    struct NetworkAuth {
        static let kFacebookAppId = "fb425217154570731"
        static let kGoogleClientId = "245895770851-qlolkejdjnske28jmbdgs89969o0a7ec.apps.googleusercontent.com"
    }
}


struct SizeConstants {
    static let screenWith = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    
    /** There are some differences in interface for small screens (iPhone4 & iPhone5). We can detect such device by width. */
    static let isSmallScreen = screenWith < 350
    
    /** For separators. Depends on screen scale */
    static let lineWidth = 1.0 / UIScreen.main.scale
}



