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
    static let ButtonHeight: CGFloat = 44
    static let ButtonWidth: CGFloat = 108
    /// Margin from right anchor of safe area to right anchor of Image
    static let ButtonRightMargin: CGFloat = Device.model == .iPhoneSE ? 12 : 20
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ButtonBottomMargin: CGFloat = 8
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title,
    /// please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class ResizableNavigationBarButton: UIButton {
    
    private var bottomConstraint: NSLayoutConstraint?
    private var rightMarginConstraint: NSLayoutConstraint?
    
    init(title: String, tintColor: UIColor = .white) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(tintColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        roundCorners(radius: BarButtonConst.ButtonHeight / 2,
                         borderWidth: Constants.Sizes.lineWidth,
                         borderColor: tintColor)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addToNavigationBar(_ navigationBar: UINavigationBar) {
        
        navigationBar.addSubview(self)
        
        bottomConstraint = self.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                                        constant: -BarButtonConst.ButtonBottomMargin)
        rightMarginConstraint = self.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                                            constant: -BarButtonConst.ButtonRightMargin)
        
        NSLayoutConstraint.activate([
            bottomConstraint!,
            rightMarginConstraint!,
            self.heightAnchor.constraint(equalToConstant: BarButtonConst.ButtonHeight),
            self.widthAnchor.constraint(equalToConstant: BarButtonConst.ButtonWidth)
            ])
        
    }
    
    func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = min(BarButtonConst.NavBarHeightLargeState, height) - BarButtonConst.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (BarButtonConst.NavBarHeightLargeState - BarButtonConst.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let borderColor = UIColor.white.withAlphaComponent(coeff)
        layer.borderColor = borderColor.cgColor
        bottomConstraint?.constant = -BarButtonConst.ButtonBottomMargin * coeff
        rightMarginConstraint?.constant = -BarButtonConst.ButtonRightMargin * coeff
    }
    
}
