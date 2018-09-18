//
//  PasswordView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

public protocol PasswordInputCompleteProtocol: class {
    func passwordInputComplete(input: String)
    func touchAuthenticationComplete(success: Bool, error: String?)
}

open class PasswordContainerView: UIView {
    
    //MARK: IBOutlet
    @IBOutlet open var passwordInputViews: [PasswordInputView]!
    @IBOutlet open weak var passwordDotView: PasswordDotView!
    @IBOutlet open weak var deleteButton: UIButton!
    @IBOutlet open weak var touchAuthenticationButton: UIButton!
    
    //MARK: Property
    open weak var delegate: PasswordInputCompleteProtocol?
    
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
            deleteButton.setTitleColor(tintColor, for: UIControlState())
            passwordDotView.strokeColor = tintColor
            touchAuthenticationButton.tintColor = tintColor
            passwordInputViews.forEach {
                $0.textColor = tintColor
                $0.borderColor = tintColor
            }
        }
    }
    
    open var highlightedColor: UIColor! {
        didSet {
            passwordDotView.fillColor = highlightedColor
            passwordInputViews.forEach {
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
    
    //MARK: AutoLayout
    open var width: CGFloat = 0 {
        didSet {
            self.widthConstraint.constant = width
        }
    }
    
    // FIXME: - resolve hardcode
    fileprivate var kDefaultWidth: CGFloat = 261
    fileprivate var kDefaultHeight: CGFloat = 390
    fileprivate var widthConstraint: NSLayoutConstraint!
    
    fileprivate func configureConstraints() {
        let ratioConstraint = widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: kDefaultWidth / kDefaultHeight)
        self.widthConstraint = widthAnchor.constraint(equalToConstant: kDefaultWidth)
        self.widthConstraint.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([ratioConstraint, widthConstraint])
    }
    
    //MARK: Init
    open class func create(withDigit digit: Int) -> PasswordContainerView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "PasswordContainerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! PasswordContainerView
        view.passwordDotView.totalDotCount = digit
        return view
    }
    
    open class func create(in stackView: UIStackView, digit: Int, defaultWidth: CGFloat = 261, defaultHeight: CGFloat = 390) -> PasswordContainerView {
        let passwordContainerView = create(withDigit: digit)
        passwordContainerView.kDefaultWidth = defaultWidth
        passwordContainerView.kDefaultHeight = defaultHeight
        stackView.addArrangedSubview(passwordContainerView)
        return passwordContainerView
    }
    
    //MARK: Life Cycle
    open override func awakeFromNib() {
        super.awakeFromNib()
        configureConstraints()
        checkInputEmpty()
        
        backgroundColor = .clear
        passwordInputViews.forEach {
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
            if let delegate = delegate {
                delegate.passwordInputComplete(input: inputString)
            } else {
                log.warn("delegate is nil")
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
        
        touchAuthenticationButton.setImage(image, for: UIControlState())
        touchAuthenticationButton.tintColor = tintColor
    }
}

extension PasswordContainerView: PasswordInputViewTappedProtocol {
    public func passwordInputView(_ passwordInputView: PasswordInputView, tappedString: String) {
        guard inputString.count < passwordDotView.totalDotCount else {
            return
        }
        
        inputString += tappedString
    }
}
