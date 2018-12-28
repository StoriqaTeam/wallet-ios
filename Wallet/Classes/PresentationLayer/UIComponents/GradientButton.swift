//
//  GradientButton.swift
//  Wallet
//
//  Created by Storiqa on 28/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit


class GradientButton: BaseButton {
    
    var buttonHeight: CGFloat {
        return Constants.Sizes.buttonHeight
    }
    
    var borderColors: [CGColor] = Theme.Color.Button.borderGradient
    var titleColor: UIColor = Theme.Color.Button.enabledTitle
    
    private var gradientLayer = CAGradientLayer()
    
    override var isEnabled: Bool {
        didSet { updateColors() }
    }
    
    override var bounds: CGRect {
        didSet {
            setGradientBounds()
            updateColors()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setHeight()
        setGradientBounds()
        updateColors()
        setTitleColor()
        backgroundColor = .clear
    }
    
    func updateColors() {
        if isEnabled {
            setEnabled()
        } else {
            setDisabled()
        }
    }
    
    func setup(colors: [CGColor], titleColor: UIColor) {
        self.borderColors = colors.count == 1 ? colors + colors : colors
        self.titleColor = titleColor
        
        setTitleColor()
        updateColors()
    }
}


// MARK: - Private methods

extension GradientButton {
    
    private func setEnabled() {
        gradientLayer.colors = borderColors
    }
    
    private func setDisabled() {
        gradientLayer.colors = borderColors.compactMap { $0.copy(alpha: 0.4) }
    }
    
    private func setTitleColor() {
        setTitleColor(titleColor, for: .normal)
        
        let alphaColor = titleColor.withAlphaComponent(0.3)
        setTitleColor(alphaColor, for: .disabled)
        setTitleColor(alphaColor, for: .highlighted)
        setTitleColor(alphaColor, for: .selected)
    }
    
    private func setHeight() {
        let height = self.constraints.first { (constraint) -> Bool in
            return constraint.firstAttribute == NSLayoutConstraint.Attribute.height
        }
        
        height?.constant = buttonHeight
    }
    
    private func setGradientBounds() {
        gradientLayer.removeFromSuperlayer()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = borderColors
        gradientLayer.startPoint = CGPoint(x: -0.5, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.7)
        
        var frame = bounds
        frame.size.height -= 2
        frame.size.width -= 2
        frame.origin = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: frame, cornerRadius: frame.height/2).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shape
        
        layer.addSublayer(gradientLayer)
    }
}
