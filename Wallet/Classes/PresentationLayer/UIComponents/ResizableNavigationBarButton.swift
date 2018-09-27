//
//  ResizableNavigationBarButton.swift
//  Wallet
//
//  Created by user on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

private struct BarButtonConst {
    /// Image height/width for Large NavBar state
    static let ButtonHeightForLargeState: CGFloat = 44
    static let ButtonWidthForLargeState: CGFloat = 108
    /// Margin from right anchor of safe area to right anchor of Image
    static let ButtonRightMargin: CGFloat = Device.model == .iPhoneSE ? 12 : 20
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ButtonBottomMarginForLargeState: CGFloat = 8
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ButtonBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ButtonHeightForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class ResizableNavigationBarButton: UIButton {
    
    init(title: String, tintColor: UIColor = .mainBlue) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(tintColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        roundCorners(radius: BarButtonConst.ButtonHeightForLargeState / 2,
                         borderWidth: Constants.Sizes.lineWidth,
                         borderColor: UIColor.mainBlue)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addToNavigationBar(_ navigationBar: UINavigationBar) {
        
        navigationBar.addSubview(self)
        NSLayoutConstraint.activate([
            self.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -BarButtonConst.ButtonRightMargin),
            self.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -BarButtonConst.ButtonBottomMarginForLargeState),
            self.heightAnchor.constraint(equalToConstant: BarButtonConst.ButtonHeightForLargeState),
            self.widthAnchor.constraint(equalToConstant: BarButtonConst.ButtonWidthForLargeState)
            ])
        
    }
    
    func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - BarButtonConst.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (BarButtonConst.NavBarHeightLargeState - BarButtonConst.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = BarButtonConst.ButtonHeightForSmallState / BarButtonConst.ButtonHeightForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = BarButtonConst.ButtonHeightForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = BarButtonConst.ButtonBottomMarginForLargeState - BarButtonConst.ButtonBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (BarButtonConst.ButtonBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        self.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
}

