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
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func dropShadow(color: UIColor = UIColor.black,
                    opacity: Float = 0.5,
                    offSet: CGSize = CGSize(width: -1, height: 1),
                    radius: CGFloat = 6,
                    scale: Bool = true) {
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
    
    func gradientView(colors: [CGColor],
                      frame: CGRect,
                      startPoint: CGPoint,
                      endPoint: CGPoint,
                      insertFirst: Bool = false) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = frame
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        if insertFirst {
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            layer.addSublayer(gradientLayer)
        }
    }
    
}


extension UIImage {
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage {
        let rectangle = CGRect(origin: CGPoint.zero, size: size)
        return getColoredRectImageWith(color: color, andRect: rectangle)
    }
    
    class func getColoredRectImageWith(color: CGColor, andRect rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = rect
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
    
}
