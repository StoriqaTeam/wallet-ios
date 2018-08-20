//
//  StqTextField.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

protocol StqTextFieldDelegate: class {
    func textFieldDidBeginEditing(_ textField: StqTextField)
    func textFieldDidEndEditing(_ textField: StqTextField)
    func textField(_ textField: StqTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldShouldReturn(_ textField: StqTextField) -> Bool
}

extension StqTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: StqTextField) {}
    func textFieldDidEndEditing(_ textField: StqTextField) {}
    func textField(_ textField: StqTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }
    func textFieldShouldReturn(_ textField: StqTextField) -> Bool { return true }
}

class StqTextField: UIView, ValidationFieldProtocol {
    typealias ValueFormat = String
    
    private var contentView: UIView?
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var imageParentView: UIView?
    @IBOutlet private var imageParentViewWidth: NSLayoutConstraint?
    
    private let emptyColor = #colorLiteral(red: 0.9450980392, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
    private let nonEmptyColor = UIColor.white
    
    weak var delegate: StqTextFieldDelegate?
    var validationBlock: ((String)->Bool)?
    
    var isValid: Bool {
        guard let text = textField.text else {
            return false
        }
        
        guard let validationBlock = validationBlock else {
            return true
        }
        
        return validationBlock(text)
    }
    
    var text: String? {
        set {
            textField.text = newValue
        }
        get {
            return textField.text
        }
    }
    
    var value: String {
        return text ?? ""
    }
    
    var validValue: String? {
        if isValid {
            return text
        } else {
            return nil
        }
    }
    
    @IBInspectable var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable var imageHidden: Bool = true {
        didSet {
            if imageHidden {
                hideImage()
            }
        }
    }
    
    @IBInspectable var image: UIImage? {
        didSet { setImage(image) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = Bundle.main.loadNibNamed("StqTextField", owner: self, options: nil)?.first as? UIView
        if let contentView = contentView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        } else {
            return nil
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = .clear //in case of setting from IB
        textField.delegate = self
        setActive()
        
        textField.font = UIFont.systemFont(ofSize: 16)
        imageView?.tintColor = #colorLiteral(red: 0.831372549, green: 0.8352941176, blue: 0.8431372549, alpha: 1)
    }
    
}

extension StqTextField {
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    var keyboardType: UIKeyboardType {
        set {
            textField.keyboardType = newValue
        }
        get {
            return textField.keyboardType
        }
    }
    
    var returnKeyType: UIReturnKeyType {
        set {
            textField.returnKeyType = newValue
        }
        get {
            return textField.returnKeyType
        }
    }
    
    var isSecureTextEntry: Bool {
        set {
            textField.isSecureTextEntry = newValue
        }
        get {
            return textField.isSecureTextEntry
        }
    }
}

private extension StqTextField {
    func setActive() {
        let active = textField.isFirstResponder || !(textField.text?.isEmpty ?? true)
        
        if active {
            contentView?.backgroundColor = nonEmptyColor
            textField.textColor = .black
            contentView?.roundCorners(borderWidth: 2, borderColor: Constants.Colors.brandColor)
        } else {
            contentView?.backgroundColor = emptyColor
            textField.textColor = Constants.Colors.grayTextColor
            contentView?.roundCorners(borderWidth: 0.0, borderColor: UIColor.clear)
        }
    }
    
    func setImage(_ image: UIImage?) {
        imageView?.image = image
        imageParentView?.isHidden = false
        imageParentViewWidth?.constant = 40
    }
    
    func hideImage() {
        imageParentView?.isHidden = true
        imageParentViewWidth?.constant = 10
    }
}

extension StqTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setActive()
        delegate?.textFieldDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setActive()
        delegate?.textFieldDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    //TODO: validation
    
}
