//
//  StepSlider.swift
//  Wallet
//
//  Created by Storiqa on 03/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class StepSlider: UISlider {
    
    private(set) var currentSliderStep = 0
    
    var paymentFeeValuesCount: Int = 1 {
        didSet {
            if paymentFeeValuesCount > 1 {
                stepLength = 1.0 / Float(paymentFeeValuesCount - 1)
                isUserInteractionEnabled = true
            } else {
                stepLength = 1
                isUserInteractionEnabled = false
            }
        }
    }
    
    private var stepLength: Float = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 1
        return newBounds
    }
    
    func updateCurrentValue(step: Int) {
        if paymentFeeValuesCount <= 1 {
            setValue(0.5, animated: false)
            currentSliderStep = step
        } else if step < paymentFeeValuesCount {
            setValue(Float(step) * stepLength, animated: false)
            currentSliderStep = step
        }
    }
        
}

// MARK: - Tracking methods

extension StepSlider {
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        calculateCurrentValue()
        return super.continueTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        calculateCurrentValue()
        setValue(Float(currentSliderStep) * stepLength, animated: false)
    }
    
}

// MARK: - Private methods

extension StepSlider {
    
    private func configure() {
        minimumTrackTintColor = Theme.Color.Slider.track
        maximumTrackTintColor = Theme.Color.Slider.track
        
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        thumbView.backgroundColor = Theme.Color.mainOrange
        thumbView.roundCorners(radius: 10)
        
        let thumbImage = asImage(view: thumbView)
        for state: UIControl.State in  [.normal, .selected, .application, .reserved, .highlighted] {
            setThumbImage(thumbImage, for: state)
        }
    }
    
    private func calculateCurrentValue() {
        let step = Int(round(value / stepLength))
        currentSliderStep = step
    }
    
    private func asImage(view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }
}
