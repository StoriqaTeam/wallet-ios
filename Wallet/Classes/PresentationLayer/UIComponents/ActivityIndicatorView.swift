//
//  WCGraintCircleLayer.swift
//  Wallet
//
//  Created by Storiqa on 24.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorView: UIView {
    private var circleLayer: WCGraintCircleLayer?
    
    func showActivityIndicator(linewidth: CGFloat = 5.0, color: UIColor = Theme.Color.brightOrange) {
        if circleLayer == nil {
            let radius = self.frame.height / 2
            circleLayer = WCGraintCircleLayer(bounds: self.bounds,
                                              position: CGPoint(x: radius, y: radius),
                                              fromColor: color,
                                              toColor: UIColor.white.withAlphaComponent(0),
                                              linewidth: linewidth,
                                              toValue: 0.98)
        }
        
        if let circleLayer = circleLayer {
            self.layer.addSublayer(circleLayer)
            circleLayer.animateRotation()
        }
    }
    
    func hideActivityIndicator() {
        circleLayer?.stopAnimating()
    }
}

private class WCGraintCircleLayer: CALayer {
    
    override init () {
        super.init()
    }
    
    convenience init(bounds: CGRect,
                     position: CGPoint,
                     fromColor: UIColor,
                     toColor: UIColor,
                     linewidth: CGFloat,
                     toValue: CGFloat = 0.99) {
        self.init()
        self.bounds = bounds
        self.position = position
        let colors: [UIColor] = self.graint(fromColor: fromColor, toColor: toColor, count: 4)
        for index in 0..<colors.count-1 {
            let graint = CAGradientLayer()
            graint.bounds = CGRect(origin: CGPoint.zero,
                                   size: CGSize(width: bounds.width/2,
                                                height: bounds.height/2))
            let valuePoint = self.positionArrayWith(bounds: self.bounds)[index]
            graint.position = valuePoint
//            print("iesimo graint position: \(graint.position)")
            let fromColor = colors[index]
            let toColor = colors[index+1]
            let colors: [CGColor] = [fromColor.cgColor, toColor.cgColor]
            let stopOne: CGFloat = 0.0
            let stopTwo: CGFloat = 1.0
            let locations: [CGFloat] = [stopOne, stopTwo]
            graint.colors = colors
            graint.locations = locations as [NSNumber]?
            graint.startPoint = self.startPoints()[index]
            graint.endPoint = self.endPoints()[index]
            self.addSublayer(graint)
            //Set mask
            let shapelayer = CAShapeLayer()
            let rect = CGRect(origin: CGPoint.zero,
                              size: CGSize(width: self.bounds.width - 2 * linewidth,
                                           height: self.bounds.height - 2 * linewidth))
            shapelayer.bounds = rect
            shapelayer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
            shapelayer.strokeColor = UIColor.blue.cgColor
            shapelayer.fillColor = UIColor.clear.cgColor
            shapelayer.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2).cgPath
            shapelayer.lineWidth = linewidth
            shapelayer.lineCap = CAShapeLayerLineCap.round
            shapelayer.strokeStart = 0.010
            let finalValue = (toValue*0.99)
            shapelayer.strokeEnd = finalValue//0.99;
            self.mask = shapelayer
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This is what you call to draw a partial circle.
    func animateCircleTo(duration: TimeInterval, fromValue: CGFloat = 0.010, toValue: CGFloat = 0.99) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.isRemovedOnCompletion = true
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0.010 (no circle) to 0.99 (full circle)
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        // Do an easeout. Don't know how to do a spring instead
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        // Set the circleLayer's strokeEnd property to 0.99 now so that it's the
        // right value when the animation ends.
        let circleMask = self.mask as! CAShapeLayer
        circleMask.strokeEnd = toValue
        
        // Do the actual animation
        circleMask.removeAllAnimations()
        circleMask.add(animation, forKey: "animateCircle")
    }
    
    func animateRotation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * -2
        rotationAnimation.duration = 1.5
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.isRemovedOnCompletion = false
        
        removeAllAnimations()
        add(rotationAnimation, forKey: "rotating")
    }
    
    func stopAnimating() {
        self.mask?.removeAllAnimations()
        removeAllAnimations()
    }
}

extension WCGraintCircleLayer {
    private func layerWithWithBounds(bounds: CGRect,
                                     position: CGPoint,
                                     fromColor: UIColor,
                                     toColor: UIColor,
                                     linewidth: CGFloat,
                                     toValue: CGFloat) -> WCGraintCircleLayer {
        let layer = WCGraintCircleLayer(bounds: bounds,
                                        position: position,
                                        fromColor: fromColor,
                                        toColor: toColor,
                                        linewidth: linewidth,
                                        toValue: toValue)
        return layer
    }
    
    private func graint(fromColor: UIColor,
                        toColor: UIColor,
                        count: Int) -> [UIColor] {
        var fromR: CGFloat = 0.0
        var fromG: CGFloat = 0.0
        var fromB: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0
        fromColor.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromAlpha)
        
        var toR: CGFloat = 0.0
        var toG: CGFloat = 0.0
        var toB: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0
        toColor.getRed(&toR, green: &toG, blue: &toB, alpha: &toAlpha)
        
        var result: [UIColor]! = [UIColor]()
        
        for index in 0...count {
            let oneR: CGFloat = fromR + (toR - fromR)/CGFloat(count) * CGFloat(index)
            let oneG: CGFloat = fromG + (toG - fromG)/CGFloat(count) * CGFloat(index)
            let oneB: CGFloat = fromB + (toB - fromB)/CGFloat(count) * CGFloat(index)
            let oneAlpha: CGFloat = fromAlpha + (toAlpha - fromAlpha)/CGFloat(count) * CGFloat(index)
            let oneColor = UIColor(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
            result.append(oneColor)
//            print(oneColor)
            
        }
        return result
    }
    
    private func positionArrayWith(bounds: CGRect) -> [CGPoint] {
        let first = CGPoint(x: (bounds.width/4)*3, y: (bounds.height/4)*1)
        let second = CGPoint(x: (bounds.width/4)*3, y: (bounds.height/4)*3)
        let third = CGPoint(x: (bounds.width/4)*1, y: (bounds.height/4)*3)
        let fourth = CGPoint(x: (bounds.width/4)*1, y: (bounds.height/4)*1)
//        print([first,second,third,fourth])
        return [first, second, third, fourth]
    }
    
    private func startPoints() -> [CGPoint] {
        return [CGPoint.zero, CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1)]
    }
    
    private func endPoints() -> [CGPoint] {
        return [CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1), CGPoint.zero, CGPoint(x: 1, y: 0)]
    }
    
    private func midColorWithFromColor(fromColor: UIColor, toColor: UIColor, progress: CGFloat) -> UIColor {
        var fromR: CGFloat = 0.0
        var fromG: CGFloat = 0.0
        var fromB: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0
        fromColor.getRed(&fromR, green: &fromG, blue: &fromB, alpha: &fromAlpha)
        
        var toR: CGFloat = 0.0
        var toG: CGFloat = 0.0
        var toB: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0
        toColor.getRed(&toR, green: &toG, blue: &toB, alpha: &toAlpha)
        
        let oneR = fromR + (toR - fromR) * progress
        let oneG = fromG + (toG - fromG) * progress
        let oneB = fromB + (toB - fromB) * progress
        let oneAlpha = fromAlpha + (toAlpha - fromAlpha) * progress
        let oneColor = UIColor(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
        return oneColor
    }
}
