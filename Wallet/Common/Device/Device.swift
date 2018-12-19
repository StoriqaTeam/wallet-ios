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
    }
    
    func flowLayout(type: FlowLayoutType) -> UICollectionViewFlowLayout {
        let size: CGSize
        let spacing: CGFloat
        let scrollDirection: UICollectionView.ScrollDirection = {
            switch type {
            case .horizontal, .horizontalSmall: return .horizontal
            case .vertical, .verticalSmall: return .vertical
            }
        }()
        
        switch type {
        case .horizontal, .vertical:
            switch self {
            case .iPhoneSE:
                size = CGSize(width: 280, height: 165)
            default:
                size = CGSize(width: 336, height: 198)
            }
        case .horizontalSmall, .verticalSmall:
            switch self {
            case .iPhoneSE:
                size = CGSize(width: 280, height: 85)
            default:
                size = CGSize(width: 336, height: 102)
            }
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        
        switch scrollDirection {
        case .horizontal:
            spacing = (Constants.Sizes.screenWidth - size.width) / 4
            flowLayout.sectionInset = UIEdgeInsets(top: 0,
                                                   left: spacing * 2,
                                                   bottom: 0,
                                                   right: spacing * 2)
        case .vertical:
            spacing = self == .iPhoneSE ? 12 : 18
            flowLayout.sectionInset = UIEdgeInsets(top: spacing / 2,
                                                   left: 0,
                                                   bottom: spacing / 2,
                                                   right: 0)
        }
        
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.itemSize = size
        flowLayout.scrollDirection = scrollDirection
        
        return flowLayout
    }
}
