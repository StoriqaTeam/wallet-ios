//
//  AgreementCell.swift
//  Wallet
//
//  Created by user on 16.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import M13Checkbox

class AgreementCell: UITableViewCell, ValidationFieldProtocol {
    typealias ValueFormat = Bool
    
    @IBOutlet private var checkboxContainer: UIView!
    @IBOutlet private var textView: UITextView!
    @IBOutlet var horisontalMargin: NSLayoutConstraint!
    
    private let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
    
    var checkboxSelected: Bool {
        set {
            checkbox.checkState = checkboxSelected ? .checked : .unchecked
        }
        get {
            return checkbox.checkState == .checked
        }
    }
    
    var isValid: Bool {
        return checkboxSelected
    }
    
    var value: Bool {
        return checkboxSelected
    }
    
    var validValue: Bool? {
        if isValid {
            return checkboxSelected
        } else {
            return nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkbox.frame = checkboxContainer.bounds
        checkboxContainer.addSubview(checkbox)
        
        checkbox.stateChangeAnimation = .bounce(.fill)
        checkbox.checkState = .unchecked
        checkbox.tintColor = Constants.Colors.brandColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class AgreementView: UIView, ValidationFieldProtocol {
    typealias ValueFormat = Bool
    
    @IBOutlet private var checkboxContainer: UIView!
    @IBOutlet private var textView: UITextView!
    
    private let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0))
    
    var checkboxSelected: Bool {
        set {
            checkbox.checkState = checkboxSelected ? .checked : .unchecked
        }
        get {
            return checkbox.checkState == .checked
        }
    }
    
    var isValid: Bool {
        return checkboxSelected
    }
    
    var value: Bool {
        return checkboxSelected
    }
    
    var validValue: Bool? {
        if isValid {
            return checkboxSelected
        } else {
            return nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkbox.frame = checkboxContainer.bounds
        checkboxContainer.addSubview(checkbox)
        
        checkbox.stateChangeAnimation = .bounce(.fill)
        checkbox.checkState = .unchecked
        checkbox.tintColor = Constants.Colors.brandColor
        
    }
}
