//
//  ThinButton.swift
//  Wallet
//
//  Created by Storiqa on 27/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//


import Foundation
import UIKit

class ThinButton: GradientButton {
    override var buttonHeight: CGFloat {
        return Constants.Sizes.smallButtonHeight
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = Theme.Font.Button.smallButtonTitle
    }
}
