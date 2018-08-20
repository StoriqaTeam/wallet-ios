//
//  StqButton.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class StqButton: UIButton {
    private var needsShadow: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        setStandartButton()
    }
    
    func setStandartButton() {
        backgroundColor = Constants.Colors.brandColor
        setTitleColor(.white, for: .normal)
        
        roundCorners()
        needsShadow = true
    }
    
    func setTransparentButton() {
        backgroundColor = .clear
        setTitleColor(Constants.Colors.brandColor, for: .normal)
        
        roundCorners(borderWidth: 2, borderColor: Constants.Colors.brandColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if needsShadow {
            dropShadow(color: Constants.Colors.brandColor, radius: 4)
        }
    }
}
