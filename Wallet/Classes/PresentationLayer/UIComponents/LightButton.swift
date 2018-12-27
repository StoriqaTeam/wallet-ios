//
//  LightButton.swift
//  Wallet
//
//  Created by Storiqa on 22.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class LightButton: BaseButton {
    
    var buttonHeight: CGFloat {
        return Constants.Sizes.buttonHeight
    }
    
    private var borderColor: UIColor = Theme.Color.Button.border
    private var titleColor: UIColor = Theme.Color.Button.enabledTitle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup(color: borderColor, titleColor: titleColor)
        titleLabel?.font = Theme.Font.Button.buttonTitle
    }
    
    override var frame: CGRect {
        didSet {
            roundView()
        }
    }
    
    func setup(color: UIColor, titleColor: UIColor? = nil) {
        self.borderColor = color
        self.titleColor = titleColor ?? color
        
        backgroundColor = .clear
        setTitleColor(titleColor, for: .normal)
        roundView()
    }
}


// MARK: - Private methods

extension LightButton {
    
    private func roundView() {
        roundCorners(radius: frame.height/2,
                     borderWidth: 1,
                     borderColor: borderColor)
    }
    
    private func setHeight() {
        let height = self.constraints.first { (constraint) -> Bool in
            return constraint.firstAttribute == NSLayoutConstraint.Attribute.height
        }
        
        height?.constant = buttonHeight
    }
    
}
