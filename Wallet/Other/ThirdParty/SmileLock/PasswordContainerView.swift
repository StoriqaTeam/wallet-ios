//
//  PasswordView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

public protocol PinInputCompleteProtocol: class {
    func pinInputComplete(input: String)
    func touchAuthenticationComplete(success: Bool, error: String?)
}

open class PasswordContainerView: UIView {
    
    //MARK: IBOutlet
    @IBOutlet open var pinInputViews: [PinInputView]!
    @IBOutlet open weak var passwordDotView: PasswordDotView!
    @IBOutlet open weak var deleteButton: UIButton!
    @IBOutlet open weak var touchAuthenticationButton: UIButton!
    
    //MARK: Property
    open weak var delegate: PinInputCompleteProtocol?
    
    private let biometryAuthProvider: BiometricAuthProviderProtocol = BiometricAuthProvider(errorParser: BiometricAuthErrorParser())
    
    fileprivate var inputString: String = "" {
        didSet {
            passwordDotView.inputDotCount = inputString.count
            checkInputComplete()
            checkInputEmpty()
        }
    }
    
    open override var tintColor: UIColor! {
        didSet {
            deleteButton.setTitleColor(tintColor, for: UIControl.State())
            passwordDotView.strokeColor = tintColor
            touchAuthenticationButton.tintColor = tintColor
            pinInputViews.forEach {
                $0.textColor = tintColor
                $0.borderColor = tintColor
            }
        }
    }
    
    open var highlightedColor: UIColor! {
        didSet {
            passwordDotView.fillColor = highlightedColor
            pinInputViews.forEach {
                $0.highlightBackgroundColor = highlightedColor
            }
        }
    }
    
    open var isTouchAuthenticationAvailable: Bool {
        return biometryAuthProvider.canAuthWithBiometry
    }
    
    open var touchAuthenticationEnabled = false {
        didSet {
            let enable = (isTouchAuthenticationAvailable && touchAuthenticationEnabled)
            touchAuthenticationButton.alpha = enable ? 1.0 : 0.0
            touchAuthenticationButton.isUserInteractionEnabled = enable
        }
    }
    
    open var touchAuthenticationReason = "Authentication is needed to access your account"
    
    //MARK: Init
    open class func create(withDigit digit: Int) -> PasswordContainerView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "PasswordContainerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! PasswordContainerView
        view.passwordDotView.totalDotCount = digit
        return view
    }
    
    open class func create(in stackView: UIStackView, digit: Int) -> PasswordContainerView {
        let passwordContainerView = create(withDigit: digit)
        stackView.addArrangedSubview(passwordContainerView)
        return passwordContainerView
    }
    
    //MARK: Life Cycle
    open override func awakeFromNib() {
        super.awakeFromNib()
        checkInputEmpty()
        
        backgroundColor = .clear
        pinInputViews.forEach {
            $0.delegate = self
        }
        deleteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deleteButton.titleLabel?.minimumScaleFactor = 0.5
        touchAuthenticationEnabled = true
        
        setAuthButtonImnage()
    }
    
    //MARK: Input Wrong
    open func wrongPassword() {
        passwordDotView.shakeAnimationWithCompletion {
            self.clearInput()
        }
    }
    
    open func clearInput() {
        inputString = ""
    }
    
    //MARK: IBAction
    @IBAction func deleteInputString(_ sender: AnyObject) {
        guard inputString.count > 0 && !passwordDotView.isFull else {
            return
        }
        inputString = String(inputString.dropLast())
    }
    
    @IBAction func touchAuthenticationAction(_ sender: UIButton) {
        guard isTouchAuthenticationAvailable else { return }
        
        biometryAuthProvider.authWithBiometry { [weak self] (success, errorMessage) in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    log.error("self is nil")
                    return
                }
                
                if success {
                    strongSelf.passwordDotView.inputDotCount = strongSelf.passwordDotView.totalDotCount
                }
                if let delegate = strongSelf.delegate {
                    delegate.touchAuthenticationComplete(success: success, error: errorMessage)
                } else {
                    log.warn("delegate is nil")
                }
            }
        }
    }
}

private extension PasswordContainerView {
    func checkInputComplete() {
        if inputString.count == passwordDotView.totalDotCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                if let inputString = self?.inputString {
                    self?.delegate?.pinInputComplete(input: inputString)
                }
            }
        }
    }
    
    func checkInputEmpty() {
        if inputString.isEmpty {
            deleteButton.isUserInteractionEnabled = false
            deleteButton.alpha = 0
        } else {
            deleteButton.isUserInteractionEnabled = true
            deleteButton.alpha = 1
        }
    }
    
    func setAuthButtonImnage() {
        let image: UIImage?
        
        switch biometryAuthProvider.biometricAuthType {
        case .faceId:
            image = #imageLiteral(resourceName: "faceid")
        case .touchId:
            image = #imageLiteral(resourceName: "touchId")
        default:
            image = nil
        }
        
        touchAuthenticationButton.setImage(image, for: UIControl.State())
        touchAuthenticationButton.tintColor = tintColor
    }
}

extension PasswordContainerView: PinInputViewTappedProtocol {
    public func pinInputView(_ pinInputView: PinInputView, tappedString: String) {
        guard inputString.count < passwordDotView.totalDotCount else {
            return
        }
        
        inputString += tappedString
    }
}
