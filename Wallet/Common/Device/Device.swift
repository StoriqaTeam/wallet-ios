//
//  Device.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 27.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


enum Device: CGFloat {
    case iPhoneSE = 568
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
            return .iPhoneSE
        default:
            return .iPhoneXSMAX
        }
    }
    
    var accountsCollectionFlowLayout: (size: CGSize, spacing: CGFloat)  {
        let size: CGSize
        
        switch self {
        case .iPhoneSE:
            size = CGSize(width: 280, height: 165)
        default:
            size = CGSize(width: 336, height: 198)
        }
        
        let spacing = (Constants.Sizes.screenWith - size.width) / 4
        return (size, spacing)
    }
    
    var myWalletCollectionFlowLayout: (size: CGSize, spacing: CGFloat) {
        switch self {
        case .iPhoneSE:
            let size = CGSize(width: 296, height: 174)
            let spacing: CGFloat = 12
            return (size, spacing)
        default:
            let size = CGSize(width: 336, height: 198)
            let spacing: CGFloat = 17
            return (size, spacing)
        }
    }
}
