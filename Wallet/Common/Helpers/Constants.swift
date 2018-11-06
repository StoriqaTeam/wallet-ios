//
//  Constants.swift
//  Wallet
//
//  Created by Storiqa on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit
import Slog

let log = Slog(level: .debug, useEmoji: false)


struct Constants {
    typealias Sizes = SizeConstants
    
    struct Network {
        static let baseUrl = "https://pay-nightly.stq.cloud/v1"
        static let ratesBaseUrl = "https://min-api.cryptocompare.com/data/pricemulti?"
    }
    
    struct Currencies {
        static let defaultFiatCurrencies =  ["USD", "EUR", "RUB"]
        static let defaultCryptoCurrencies = ["BTC", "ETH", "STQ"]
    }
    
    struct Errors {
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
    
    /** For separators. Depends on screen scale */
    static let lineWidth = 1.0 / UIScreen.main.scale
}
