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
    func textFieldShouldClear(_ textField: StqTextField) -> Bool
}

extension StqTextFieldDelegate {
    //optional methods
    func textFieldDidBeginEditing(_ textField: StqTextField) {}
    func textFieldDidEndEditing(_ textField: StqTextField) {}
    func textField(_ textField: StqTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }
    func textFieldShouldReturn(_ textField: StqTextField) -> Bool { return true }
    func textFieldShouldClear(_ textField: StqTextField) -> Bool { return true }
}

class StqTextField: UIView {
    typealias ValueFormat = String
    
    private var contentView: UIView?
    @IBOutlet private var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.font = UIFont.systemFont(ofSize: 17)
        }
    }
    @IBOutlet private var imageView: UIImageView? {
        didSet {
            imageView?.tintColor = Constants.Colors.gray
        }
    }
    @IBOutlet private var imageViewWidthConstraint: NSLayoutConstraint?
    
    weak var delegate: StqTextFieldDelegate?
    
    var text: String {
        set {
            textField.text = newValue
        }
        get {
            return textField.text ?? ""
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
        super.awakeFromNib()
        backgroundColor = .clear //in case of setting from IB
        if imageHidden {
            hideImage()
        }
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
    func setImage(_ image: UIImage?) {
        imageView?.image = image
        imageView?.isHidden = false
        imageViewWidthConstraint?.constant = 20
    }
    
    func hideImage() {
        imageView?.isHidden = true
        imageViewWidthConstraint?.constant = 0
    }
}

extension StqTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldClear(self) ?? true
    }
    
    //TODO: validation
    
}
