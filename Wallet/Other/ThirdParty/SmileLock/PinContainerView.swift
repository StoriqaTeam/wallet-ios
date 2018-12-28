//
//  PasswordView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

public protocol PinInputCompleteProtocol: class {
    func pinInputComplete(input: String)
    func authWithBiometryTapped()
}

class PinContainerView: LoadableFromXib {
    
    // MARK: IBOutlet
    
    @IBOutlet private var pinInputViews: [PinInputView]!
    @IBOutlet private var pinDotView: PinDotView!
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var touchAuthenticationButton: UIButton!
    
    private let haptic: HapticServiceProtocol = HapticService()
    
    // MARK: Property
    
    weak var delegate: PinInputCompleteProtocol?
    
    var totalDotCount = 4 {
        didSet {
            pinDotView?.totalDotCount = totalDotCount
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            pinDotView.fillColor = tintColor
            pinInputViews.forEach {
                $0.textColor = tintColor
                $0.borderColor = tintColor
            }
        }
    }
    
    var borderWidth: CGFloat! {
        didSet {
            pinInputViews.forEach {
                $0.borderWidth = borderWidth
            }
        }
    }
    
    var textFont: UIFont! {
        didSet {
            pinInputViews.forEach {
                $0.labelFont = textFont
            }
        }
    }
    
    var highlightedColor: UIColor! {
        didSet {
            pinInputViews.forEach {
                $0.highlightBackgroundColor = highlightedColor
            }
        }
    }
    
    var dotStrokeColor: UIColor! {
        didSet {
            pinDotView.strokeColor = highlightedColor
        }
    }
    
    var unhighlightedColor: UIColor! {
        didSet {
            pinDotView.emptyColor = unhighlightedColor
        }
    }
    
    var authButtonImage: UIImage? = nil {
        didSet {
            touchAuthenticationButton.setImage(authButtonImage, for: UIControl.State())
        }
    }
    
    var touchAuthenticationEnabled = false {
        didSet {
            touchAuthenticationButton.alpha = touchAuthenticationEnabled ? 1.0 : 0.0
            touchAuthenticationButton.isUserInteractionEnabled = touchAuthenticationEnabled
        }
    }
    
    private var inputString: String = "" {
        didSet {
            pinDotView.inputDotCount = inputString.count
            checkInputComplete()
            checkInputEmpty()
        }
    }
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pinInputViews.forEach {
            $0.delegate = self
        }
        checkInputEmpty()
        
        touchAuthenticationButton.tintColor = Theme.Color.brightOrange
    }
    
    // MARK: Input Wrong
    func wrongPassword() {
        haptic.performNotificationHaptic(feedbackType: .error)
        pinDotView.shakeAnimationWithCompletion {
            self.clearInput()
        }
    }
    
    func clearInput() {
        inputString = ""
    }
    
    func completeInput() {
        pinDotView.inputDotCount = pinDotView.totalDotCount
    }
    
    // MARK: IBAction
    @IBAction func deleteInputString(_ sender: AnyObject) {
        guard !inputString.isEmpty && !pinDotView.isFull else {
            return
        }
        inputString = String(inputString.dropLast())
    }
    
    @IBAction func touchAuthenticationAction(_ sender: UIButton) {
        delegate?.authWithBiometryTapped()
    }
}


// MARK: - Private methods

extension PinContainerView {
    private func checkInputComplete() {
        if inputString.count == pinDotView.totalDotCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                if let inputString = self?.inputString {
                    self?.delegate?.pinInputComplete(input: inputString)
                }
            }
        }
    }
    
    private func checkInputEmpty() {
        if inputString.isEmpty {
            deleteButton.isUserInteractionEnabled = false
            deleteButton.alpha = 0
        } else {
            deleteButton.isUserInteractionEnabled = true
            deleteButton.alpha = 1
        }
    }
}


// MARK: - PinInputViewTappedProtocol

extension PinContainerView: PinInputViewTappedDelegate {
    public func pinInputView(_ pinInputView: PinInputView, tappedString: String) {
        haptic.performImpactHaptic(style: .medium)
        guard inputString.count < pinDotView.totalDotCount else {
            return
        }
        
        inputString += tappedString
    }
}
