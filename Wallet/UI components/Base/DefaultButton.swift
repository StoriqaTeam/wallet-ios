//
//  DefaultButton.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class DefaultButton: BaseButton {
    private var needsShadow: Bool = false
    private var shadowLayer: CAShapeLayer?

    private var enabledBackgroundColor = Constants.Colors.brandColor
    private var disabledBackgroundColor = #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7764705882, alpha: 0.12)
    private var enabledTitleColor = UIColor.white
    private var disabledTitleColor = Constants.Colors.gray
    
    override var isEnabled: Bool {
        didSet {
            updateColors()
        }
    }
    
    override var frame: CGRect {
        didSet {
            roundCorners(radius: frame.height/2)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(color: UIColor? = nil, titleColor: UIColor? = nil) {
        if let color = color {
            enabledBackgroundColor = color
        }
        if let titleColor = titleColor {
            enabledTitleColor = titleColor
        }
        
        updateColors()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if needsShadow {
            dropShadow(color: enabledBackgroundColor, opacity: 0.4, radius: 10)
        } else {
            //hides shadow
            layer.shadowOpacity = 0
        }
    }
}

private extension DefaultButton {
    func updateColors() {
        if isEnabled {
            setEnabled()
        } else {
            setDisabled()
        }
    }
    
    func setEnabled() {
        needsShadow = true
        backgroundColor = enabledBackgroundColor
        setTitleColor(enabledTitleColor, for: .normal)
    }
    
    func setDisabled() {
        needsShadow = false
        backgroundColor = disabledBackgroundColor
        setTitleColor(disabledTitleColor, for: .normal)
    }
}
