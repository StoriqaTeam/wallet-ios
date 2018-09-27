//
//  Device.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 27.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


enum Device: CGFloat {
    case IphoneSE = 568
    case iPhone8 = 667
    case iPhone7Plus = 736
    case iPhoneX = 812
    case iPhoneXSMAX = 896
    
    static var model: Device {
        let height = UIScreen.main.bounds.size.height
        switch height {
        case 812:
            return .iPhoneX
        case 736:
            return .iPhone7Plus
        case 667:
            return .iPhone8
        case 568:
            return .IphoneSE
        default:
            return .iPhoneXSMAX
        }
    }
}

