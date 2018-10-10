//
//  HeaderGradientView.swift
//  Wallet
//
//  Created by Tata Gri on 10/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class HeaderGradientView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGradient()
    }
    
    override var bounds: CGRect {
        didSet { setGradient() }
    }
    
    func setHeight(height: CGFloat) {
        setGradient(height: height)
    }
    
}


// MARK: Private methods

extension HeaderGradientView {
    private func setGradient(height: CGFloat?  = nil) {
        let layerFrame: CGRect
        
        if let height = height {
            layerFrame = CGRect(x: 0, y: 0, width: frame.width, height: height)
        } else {
            layerFrame = bounds
        }
        
        layer.sublayers?.removeAll()
        
        gradientView(colors: Theme.Gradient.headerGradient,
                     frame: layerFrame,
                     startPoint: CGPoint(x: 0.0, y: 0.0),
                     endPoint: CGPoint(x: 1.0, y: 1.0))
    }
}
