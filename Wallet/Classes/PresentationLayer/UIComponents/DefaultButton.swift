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
