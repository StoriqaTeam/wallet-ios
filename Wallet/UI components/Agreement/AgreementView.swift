//
//  AgreementCell.swift
//  Wallet
//
//  Created by user on 16.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import M13Checkbox

class AgreementView: UIView {
    @IBOutlet private var checkboxContainer: UIView!
    @IBOutlet private var textView: UITextView? {
        didSet {
            textView?.text = text
        }
    }
    
    private let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
    
    var text: String = "" {
        didSet {
            textView?.text = text
        }
    }
    
    var checkboxSelected: Bool {
        set {
            checkbox.checkState = checkboxSelected ? .checked : .unchecked
        }
        get {
            return checkbox.checkState == .checked
        }
    }
    
    var valueChangedBlock: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkbox.frame = checkboxContainer.bounds
        checkboxContainer.addSubview(checkbox)
        
        checkbox.stateChangeAnimation = .bounce(.fill)
        checkbox.checkState = .unchecked
        checkbox.tintColor = Constants.Colors.brandColor
        checkbox.addTarget(self, action: #selector(checkboxValueChanged), for: .valueChanged)
    }
    
    @objc private func checkboxValueChanged() {
        valueChangedBlock?()
    }
}
