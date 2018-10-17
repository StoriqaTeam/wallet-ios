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
    private var borderColor: UIColor = Theme.Color.brightSkyBlue
    private var borderAlpha: CGFloat = 0.18
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup(color: Theme.Color.brightSkyBlue)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    override var frame: CGRect {
        didSet {
            roundView()
        }
    }
    
    func setup(color: UIColor, borderAlpha: CGFloat? = nil) {
        if let borderAlpha = borderAlpha {
            self.borderAlpha = borderAlpha
        }
        
        borderColor = color
        backgroundColor = .clear
        setTitleColor(color, for: .normal)
        roundView()
    }
}


// MARK: - Private methods

extension LightButton {
    
    private func roundView() {
        roundCorners(radius: frame.height/2,
                     borderWidth: 1,
                     borderColor: borderColor.withAlphaComponent(borderAlpha))
    }
    
}
