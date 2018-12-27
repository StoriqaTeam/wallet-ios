//
//  DefaultButton.swift
//  Wallet
//
//  Created by Storiqa on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit


// ------------------------------------------------------------------------------------------
//
// NEW VERSION
//
// ------------------------------------------------------------------------------------------


//class CustomButton: DefaultButton {
//
//    override var buttonHeight: CGFloat {
//        return Constants.Sizes.smallButtonHeight
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        titleLabel?.font = Theme.Font.Button.smallButtonTitle
//    }
//
//
//    func setup(color: UIColor, titleColor: UIColor? = nil) {
//        self.borderColor = color
//        self.titleColor = titleColor ?? color
//
//        backgroundColor = .clear
//        setTitleColor(titleColor, for: .normal)
//        updateColors()
//    }
//}
//
//class DefaultButton: BaseButton {
//
//    var buttonHeight: CGFloat {
//        return Constants.Sizes.buttonHeight
//    }
//
//    var borderColor: UIColor = Theme.Color.Button.border
//    var titleColor: UIColor = Theme.Color.Button.enabledTitle
//
//    override var isEnabled: Bool {
//        didSet { updateColors() }
//    }
//
//    override var frame: CGRect {
//        didSet { roundView() }
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setHeight()
//        roundView()
//        updateColors()
//        backgroundColor = .clear
//        titleLabel?.font = Theme.Font.Button.buttonTitle
//    }
//
//    func updateColors() {
//        if isEnabled {
//            setEnabled()
//        } else {
//            setDisabled()
//        }
//    }
//}
//
//
//// MARK: - Private methods
//
//extension DefaultButton {
//
//    private func setEnabled() {
//        setTitleColor(titleColor, for: .normal)
//        layer.borderColor = borderColor.cgColor
//    }
//
//    private func setDisabled() {
//        setTitleColor(titleColor.withAlphaComponent(0.3), for: .normal)
//        layer.borderColor = borderColor.withAlphaComponent(0.4).cgColor
//    }
//
//    private func roundView() {
//        roundCorners(radius: frame.height/2,
//                     borderWidth: 1,
//                     borderColor: borderColor)
//    }
//
//    private func setHeight() {
//        let height = self.constraints.first { (constraint) -> Bool in
//            return constraint.firstAttribute == NSLayoutConstraint.Attribute.height
//        }
//
//        height?.constant = buttonHeight
//    }
//}


// ------------------------------------------------------------------------------------------
//
// OLD VERSION
//
// ------------------------------------------------------------------------------------------

class DefaultButton: BaseButton {
    
    var buttonHeight: CGFloat {
        return Constants.Sizes.buttonHeight
    }
    
    private let enabledBackgroundColor = Theme.Color.Button.enabledBackground
    private let disabledBackgroundColor = Theme.Color.Button.disabledBackground
    private let enabledTitleColor = Theme.Color.Button.enabledTitle
    private let disabledTitleColor = Theme.Color.Button.disabledTitle

    override var isEnabled: Bool {
        didSet {
            updateColors()
        }
    }

    override var frame: CGRect {
        didSet {
            roundCorners(radius: frame.height/2)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateColors()
        titleLabel?.font = Theme.Font.Button.buttonTitle
    }
}

// MARK: - Private methods

extension DefaultButton {
    private func updateColors() {
        if isEnabled {
            setEnabled()
        } else {
            setDisabled()
        }
    }

    private func setEnabled() {
        backgroundColor = enabledBackgroundColor
        setTitleColor(enabledTitleColor, for: .normal)
    }

    private func setDisabled() {
        backgroundColor = disabledBackgroundColor
        setTitleColor(disabledTitleColor, for: .normal)
    }
    
    private func setHeight() {
        let height = self.constraints.first { (constraint) -> Bool in
            return constraint.firstAttribute == NSLayoutConstraint.Attribute.height
        }
        
        height?.constant = buttonHeight
    }
}
