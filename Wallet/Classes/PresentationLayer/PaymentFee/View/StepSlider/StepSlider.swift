//
//  StepSlider.swift
//  Wallet
//
//  Created by user on 03/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class StepSlider: UISlider {
    
    private(set) var currentSliderStep = 0
    
    var paymentFeeValuesCount: Int = 1 {
        didSet {
            if paymentFeeValuesCount > 1 {
                stepLength = 1.0 / Float(paymentFeeValuesCount - 1)
            } else {
                stepLength = 1
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
    
    func updateCurrentValue(step: Int) {
        if step < paymentFeeValuesCount {
            setValue(Float(step) * stepLength, animated: false)
            currentSliderStep = step
        }
    }
        
}

//MARK: - Tracking methods

extension StepSlider {
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        calculateCurrentValue()
        return super.continueTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        calculateCurrentValue()
    }
    
}

//MARK: - Private methods

extension StepSlider {
    
    private func configure() {
        minimumTrackTintColor = UIColor.mainBlue
        maximumTrackTintColor = UIColor.mainBlue
        
        let thumbImage = #imageLiteral(resourceName: "thumbImage")
        for state: UIControlState in  [.normal, .selected, .application, .reserved, .highlighted] {
            setThumbImage(thumbImage, for: state)
        }
    }
    
    private func calculateCurrentValue() {
        let step = Int(round(value / stepLength))
        setValue(Float(step) * stepLength, animated: false)
        currentSliderStep = step
    }
}
