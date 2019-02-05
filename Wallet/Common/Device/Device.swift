//
//  Device.swift
//  Wallet
//
//  Created by Storiqa on 27.09.2018.
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
    
    enum FlowLayoutType {
        case vertical
        case horizontal
        case verticalSmall
        case horizontalSmall
        case horizontalThin
    }
    
    func flowLayout(type: FlowLayoutType) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let inset = self == .iPhoneSE ? CGFloat(8) : CGFloat(20)
        let width = Constants.Sizes.screenWidth - inset * 2
        
        switch type {
        case .horizontal, .vertical:
            let height = width * 0.6
            flowLayout.itemSize = CGSize(width: width, height: height)
        case .horizontalSmall, .verticalSmall:
            let height = width * 0.3
            flowLayout.itemSize = CGSize(width: width, height: height)
        case .horizontalThin:
            let height = width * 0.175
            flowLayout.itemSize = CGSize(width: width, height: height)
            
        }
        
        switch type {
        case .horizontal, .horizontalSmall, .horizontalThin:
            flowLayout.minimumInteritemSpacing = inset / 2
            flowLayout.minimumLineSpacing = inset / 2
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
            flowLayout.scrollDirection = .horizontal
        case .vertical:
            let spacing: CGFloat = -(flowLayout.itemSize.height * 0.73)
            flowLayout.minimumLineSpacing = spacing
            flowLayout.sectionInset = UIEdgeInsets(top: inset/2, left: 0, bottom: inset/2, right: 0)
            flowLayout.scrollDirection = .vertical
            flowLayout.footerReferenceSize = CGSize(width: width, height: 80)
        case .verticalSmall:
            flowLayout.minimumLineSpacing = inset
            flowLayout.sectionInset = UIEdgeInsets(top: inset/2, left: 0, bottom: inset/2, right: 0)
            flowLayout.scrollDirection = .vertical
        }
        
        return flowLayout
    }
}
