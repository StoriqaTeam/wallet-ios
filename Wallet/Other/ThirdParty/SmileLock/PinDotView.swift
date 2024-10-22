//
//  PinDotView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

class PinDotView: UIView {
    
    // MARK: Property
    var inputDotCount = 0 {
        didSet { setNeedsDisplay() }
    }
    
    var totalDotCount = 4 {
        didSet { setNeedsDisplay() }
    }
    
    var strokeColor = UIColor.darkGray {
        didSet { setNeedsDisplay() }
    }
    
    var fillColor = UIColor.red {
        didSet { setNeedsDisplay() }
    }
    
    var emptyColor = UIColor.red {
        didSet { setNeedsDisplay() }
    }
    
    private let radius: CGFloat = 4.5
    private let spacingRatio: CGFloat = 5
    private let borderWidthRatio: CGFloat = 1/5
    
    private(set) var isFull = false
    
    // MARK: Draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        isFull = (inputDotCount == totalDotCount)
        strokeColor.setStroke()
        
        let isOdd = (totalDotCount % 2) != 0
        let positions = getDotPositions(isOdd)
        let borderWidth = radius * borderWidthRatio
        
        for (index, position) in positions.enumerated() {
            let radius: CGFloat
            
            if index < inputDotCount {
                radius = self.radius + borderWidth / 2
                fillColor.setFill()
            } else {
                radius = self.radius
                emptyColor.setFill()
            }
            
            let pathToFill = UIBezierPath(circleWithCenter: position, radius: radius, lineWidth: borderWidth)
            
            if index < inputDotCount {
                let shadowOffset = CGSize(width: 0, height: 0)
                let shadowBlurRadius: CGFloat = radius * 2
                
                if let context = UIGraphicsGetCurrentContext() {
                    context.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: fillColor.withAlphaComponent(0.8).cgColor)
                    pathToFill.fill()
                }
            } else {
                pathToFill.fill()
                pathToFill.stroke()
            }
            
        }
    }
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    
    // MARK: Animation
    private var shakeCount = 0
    private var direction = false
    
    func shakeAnimationWithCompletion(_ completion: @escaping () -> Void) {
        let maxShakeCount = 5
        let centerX = frame.midX
        let centerY = frame.midY
        var duration = 0.10
        var moveX: CGFloat = 5
        
        if shakeCount == 0 || shakeCount == maxShakeCount {
            duration *= 0.5
        } else {
            moveX *= 2
        }
        
        shakeAnimation(withDuration: duration, animations: {
            if !self.direction {
                self.center = CGPoint(x: centerX + moveX, y: centerY)
            } else {
                self.center = CGPoint(x: centerX - moveX, y: centerY)
            }
        }, completion: {
            if self.shakeCount >= maxShakeCount {
                self.shakeAnimation(withDuration: duration, animations: {
                    let realCenterX = self.superview!.bounds.midX
                    self.center = CGPoint(x: realCenterX, y: centerY)
                }, completion: {
                    self.direction = false
                    self.shakeCount = 0
                    completion()
                })
            } else {
                self.shakeCount += 1
                self.direction.toggle()
                self.shakeAnimationWithCompletion(completion)
            }
        })
    }
}

private extension PinDotView {
    // MARK: Animation
    func shakeAnimation(withDuration duration: TimeInterval,
                        animations: @escaping () -> Void,
                        completion: @escaping () -> Void) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.01,
                       initialSpringVelocity: 0.35,
                       options: UIView.AnimationOptions(),
                       animations: { animations() },
                       completion: { _ in completion() })
    }
    
    // MARK: Dots Layout
    func getDotPositions(_ isOdd: Bool) -> [CGPoint] {
        let centerX = bounds.midX
        let centerY = bounds.midY
        let spacing = radius * spacingRatio
        let middleIndex = isOdd ? (totalDotCount + 1) / 2 : (totalDotCount) / 2
        let offSet = isOdd ? 0 : -(radius + spacing / 2)
        let positions: [CGPoint] = (1...totalDotCount).map { index in
            let positionX = centerX - (radius * 2 + spacing) * CGFloat(middleIndex - index) + offSet
            return CGPoint(x: positionX, y: centerY)
        }
        return positions
    }
}

internal extension UIBezierPath {
    convenience init(circleWithCenter center: CGPoint, radius: CGFloat, lineWidth: CGFloat) {
        self.init(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(Double.pi), clockwise: false)
        self.lineWidth = lineWidth
    }
}
