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
    private var borderColor: UIColor = Theme.Color.Button.border
    private var titleColor: UIColor = Theme.Color.Button.enabledTitle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup(color: borderColor, titleColor: titleColor)
        titleLabel?.font = Theme.Font.Button.smallButtonTitle
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
    
}
