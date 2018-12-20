//
//  DefaultButton.swift
//  Wallet
//
//  Created by Storiqa on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class DefaultButton: BaseButton {
    private let enabledBackgroundColor = Theme.Button.Color.enabledBackground
    private let disabledBackgroundColor = Theme.Button.Color.disabledBackground
    private let enabledTitleColor = Theme.Button.Color.enabledTitle
    private let disabledTitleColor = Theme.Button.Color.disabledTitle
    
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
        titleLabel?.font = Theme.Font.buttonTitle
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
}
