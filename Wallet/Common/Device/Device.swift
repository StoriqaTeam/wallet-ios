//
//  Device.swift
//  Wallet
//
//  Created by Storiqa on 27.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable cyclomatic_complexity

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
        let itemSpacing: CGFloat
        let lineSpacing: CGFloat
        let scrollDirection: UICollectionView.ScrollDirection
        
        switch type {
        case .horizontal:
            scrollDirection = .horizontal
            
            switch self {
            case .iPhoneSE:
                size = CGSize(width: 280, height: 165)
            default:
                size = CGSize(width: 336, height: 198)
            }
            
            itemSpacing = (Constants.Sizes.screenWidth - size.width) / 2
            lineSpacing = itemSpacing / 2
        case .horizontalSmall:
            scrollDirection = .horizontal
            
            switch self {
            case .iPhoneSE:
                size = CGSize(width: 280, height: 85)
            default:
                size = CGSize(width: 336, height: 102)
            }
            
            itemSpacing = (Constants.Sizes.screenWidth - size.width) / 2
            lineSpacing = itemSpacing / 2
        case .vertical:
            scrollDirection = .vertical
            
            switch self {
            case .iPhoneSE:
                size = CGSize(width: 280, height: 165)
            default:
                size = CGSize(width: 336, height: 198)
            }
            
            itemSpacing = (Constants.Sizes.screenWidth - size.width) / 2
            lineSpacing = itemSpacing
        case .verticalSmall:
            scrollDirection = .vertical
            
            switch self {
            case .iPhoneSE:
                size = CGSize(width: 280, height: 85)
                itemSpacing = 12
                lineSpacing = 12
            default:
                size = CGSize(width: 336, height: 102)
                itemSpacing = 17
                lineSpacing = 17
            }
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.minimumInteritemSpacing = itemSpacing
        
        switch scrollDirection {
        case .horizontal:
            flowLayout.sectionInset = UIEdgeInsets(top: 0,
                                                   left: lineSpacing * 2,
                                                   bottom: 0,
                                                   right: lineSpacing * 2)
        case .vertical:
            flowLayout.sectionInset = UIEdgeInsets(top: lineSpacing / 2,
                                                   left: 0,
                                                   bottom: lineSpacing / 2,
                                                   right: 0)
        }
        
        flowLayout.itemSize = size
        flowLayout.scrollDirection = scrollDirection
        
        return flowLayout
    }
}
