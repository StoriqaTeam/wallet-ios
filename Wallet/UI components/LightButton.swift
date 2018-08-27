//
//  LightButton.swift
//  Wallet
//
//  Created by user on 22.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class LightButton: BaseButton {
    private var borderColor: UIColor = UIColor.brightSkyBlue
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup(color: UIColor.brightSkyBlue)
    }
    
    override var frame: CGRect {
        didSet {
            roundCorners(radius: frame.height/2, borderWidth: Constants.Sizes.lineWidth, borderColor: borderColor)
        }
    }
    
    func setup(color: UIColor) {
        borderColor = color
        backgroundColor = .clear
        setTitleColor(color, for: .normal)
    }
}
