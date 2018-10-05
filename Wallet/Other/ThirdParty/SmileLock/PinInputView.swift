//
//  PinInputView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

protocol PinInputViewTappedDelegate: class {
    func pinInputView(_ pinInputView: PinInputView, tappedString: String)
}

@IBDesignable
class PinInputView: UIView {
    
    // MARK: Property
    weak var delegate: PinInputViewTappedDelegate?
    
    private let circleView = UIView()
    private let button = UIButton()
    private let label = UILabel()
    private var touchUpFlag = true
    private(set) var isAnimating = false
    
    @IBInspectable
    var numberString: String = "?" {
        didSet {
            label.text = numberString
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.gray {
        didSet {
            circleView.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var circleBackgroundColor: UIColor = UIColor.clear {
        didSet {
            circleView.backgroundColor = circleBackgroundColor
        }
    }
    
    @IBInspectable
    var textColor: UIColor = UIColor.darkGray {
        didSet {
            label.textColor = textColor
        }
    }
    
    var labelFont: UIFont = UIFont.systemFont(ofSize: 36, weight: .light) {
        didSet {
            label.font = labelFont
        }
    }
    
    @IBInspectable
    var highlightBackgroundColor: UIColor = UIColor.red
    
    @IBInspectable
    var highlightTextColor: UIColor = UIColor.white
    
    @IBInspectable
    var borderOpacity: CGFloat = 0.2
    
    @IBInspectable
    var borderWidth: CGFloat = 1
    
    // MARK: Life Cycle
    override  func awakeFromNib() {
        super.awakeFromNib()
        configureSubviews()
    }
    
    @objc func touchDown() {
        //delegate callback
        if let delegate = delegate {
            delegate.pinInputView(self, tappedString: numberString)
        } else {
            log.warn("delegate is nil")
        }
        
        //now touch down, so set touch up flag --> false
        touchUpFlag = false
        touchDownAnimation()
    }
    
    @objc func touchUp() {
        //now touch up, so set touch up flag --> true
        touchUpFlag = true
        
        //only show touch up animation when touch down animation finished
        if !isAnimating {
            touchUpAnimation()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    private func updateUI() {
        //prepare calculate
        let width = bounds.width
        let height = bounds.height
        let center = CGPoint(x: width/2, y: height/2)
        let radius = min(width, height) / 2
        let circleRadius = radius - borderWidth
        
        //update circle view
        circleView.frame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleView.center = center
        circleView.layer.cornerRadius = circleRadius
        circleView.backgroundColor = circleBackgroundColor
        //circle view border
        circleView.layer.borderWidth = borderWidth
        circleView.layer.borderColor = borderColor.withAlphaComponent(borderOpacity).cgColor
        
        //update mask
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(Double.pi), clockwise: false)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}

// MARK: - Private methods

extension PinInputView {
    // MARK: Awake
    private func configureSubviews() {
        //update color
        backgroundColor = .clear
        addSubview(circleView)
        
        //configure label
        addEqualConstraintsFromSubView(label, toSuperView: self)
        label.textAlignment = .center
        label.text = numberString
        label.font = labelFont
        label.textColor = textColor
        
        //configure button
        addEqualConstraintsFromSubView(button, toSuperView: self)
        button.isExclusiveTouch = true
        button.addTarget(self,
                         action: #selector(PinInputView.touchDown),
                         for: [.touchDown])
        button.addTarget(self,
                         action: #selector(PinInputView.touchUp),
                         for: [.touchUpInside, .touchDragOutside, .touchCancel, .touchDragExit])
    }
    
    // MARK: Animation
    private func touchDownAction() {
        label.textColor = highlightTextColor
        circleView.backgroundColor = highlightBackgroundColor
    }
    
    private func touchUpAction() {
        label.textColor = textColor
        circleView.backgroundColor = circleBackgroundColor
    }
    
    private func touchDownAnimation() {
        isAnimating = true
        tappedAnimation(animations: { 
            self.touchDownAction()
        }, completion: {
            if self.touchUpFlag {
                self.touchUpAnimation()
            } else {
                self.isAnimating = false
            }
        })
    }
    
    private func touchUpAnimation() {
        isAnimating = true
        tappedAnimation(animations: { 
            self.touchUpAction()
        }, completion: {
            self.isAnimating = false
        })
    }
    
    private func tappedAnimation(animations: @escaping () -> Void, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.allowUserInteraction, .beginFromCurrentState],
                       animations: animations,
                       completion: { _ in completion?() })
    }
}

// MARK: - NSLayoutConstraint
extension PinInputView {
    private func addConstraints(fromView view: UIView,
                                toView baseView: UIView,
                                constraintInsets insets: UIEdgeInsets) {
        baseView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top)
        let topConstraint = baseView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top)
        let bottomConstraint = baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        let leftConstraint = baseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left)
        let rightConstraint = baseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    private func addEqualConstraintsFromSubView(_ subView: UIView,
                                                toSuperView superView: UIView) {
        superView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(fromView: subView, toView: superView, constraintInsets: UIEdgeInsets.zero)
    }
    
    private func addConstraints(fromSubview subview: UIView,
                                toSuperView superView: UIView,
                                constraintInsets insets: UIEdgeInsets) {
        superView.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(fromView: subview, toView: superView, constraintInsets: insets)
    }
}
