//
//  UIViewExtension.swift
//  Wallet
//
//  Created by Storiqa on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(radius: CGFloat, borderWidth: CGFloat = 0.0, borderColor: UIColor = .clear) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func dropShadow(color: UIColor = UIColor.black, opacity: Float = 0.5, offSet: CGSize = CGSize(width: -1, height: 1), radius: CGFloat = 6, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func underlineView(color: UIColor) -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        addSubview(lineView)
        
        let metrics = ["width": NSNumber(value: Double(Constants.Sizes.lineWidth))]
        let views = ["lineView": lineView]
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: metrics,
                                                                  views: views)
        let vericalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                               metrics: metrics,
                                                               views: views)
        self.addConstraints(horizontalConstraint)
        self.addConstraints(vericalConstraint)
        
        return lineView
    }
    
    func gradientView(colors: [CGColor], frame: CGRect, startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = frame
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.addSublayer(gradientLayer)
    }
    
    func accountsHeaderGradientView(height: CGFloat? = nil) {
        let layerFrame: CGRect
        
        if let height = height {
            layerFrame = CGRect(x: 0, y: 0, width: frame.width, height: height)
        } else {
            layerFrame = bounds
        }
        
        let colors = [ UIColor(red: 65/255, green: 183/255, blue: 244/255, alpha: 1).cgColor,
                       UIColor(red: 45/255, green: 100/255, blue: 194/255, alpha: 1).cgColor ]
        
        gradientView(colors: colors,
                     frame: layerFrame,
                     startPoint: CGPoint(x: 0.0, y: 0.0),
                     endPoint: CGPoint(x: 1.0, y: 1.0))
    }
}
