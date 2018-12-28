//
//  BaseButton.swift
//  Wallet
//
//  Created by Storiqa on 22.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class BaseButton: UIButton {
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = Theme.Font.Button.buttonTitle
        setTitleColor(Theme.Color.Button.enabledTitle, for: .normal)
        
        let alphaColor = Theme.Color.Button.enabledTitle.withAlphaComponent(0.3)
        setTitleColor(alphaColor, for: .disabled)
        setTitleColor(alphaColor, for: .highlighted)
        setTitleColor(alphaColor, for: .selected)
    }
}

class ColoredFramelessButton: BaseButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(Theme.Color.Button.tintColor, for: .normal)
        
        let alphaColor = Theme.Color.Button.tintColor.withAlphaComponent(0.3)
        setTitleColor(alphaColor, for: .disabled)
        setTitleColor(alphaColor, for: .highlighted)
        setTitleColor(alphaColor, for: .selected)
    }
}
