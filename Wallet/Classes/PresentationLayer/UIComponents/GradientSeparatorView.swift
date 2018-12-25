//
//  GradientSeparatorView.swift
//  Wallet
//
//  Created by Storiqa on 25/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

import UIKit

class GradientSeparatorView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setGradient()
    }
    
    override var bounds: CGRect {
        didSet { setGradient() }
    }
    
    private func setGradient() {
        backgroundColor = UIColor.clear
        var frame = self.bounds
        frame.size.height = 1.4
        
        gradientView(colors: Theme.Color.Gradient.detailsRedGradient,
                     frame: frame,
                     startPoint: CGPoint(x: 0.0, y: 0.5),
                     endPoint: CGPoint(x: 1.0, y: 0.5))
    }
}
