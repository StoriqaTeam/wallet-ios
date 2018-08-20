//
//  StqButton.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class StqButton: UIButton {
    private var enabledBackgroundColor = Constants.Colors.brandColor
    private var disabledBackgroundColor = #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7764705882, alpha: 0.12)
    private var enabledTitleColor = UIColor.white
    private var disabledTitleColor = Constants.Colors.gray
    
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
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
        
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setStandartButton()
    }
    
    func setStandartButton(color: UIColor? = nil, titleColor: UIColor? = nil) {
        if let color = color {
            enabledBackgroundColor = color
        }
        if let titleColor = titleColor {
            enabledTitleColor = titleColor
        }
        
        updateColors()
    }
}

private extension StqButton {
    func updateColors() {
        if isEnabled {
            setEnabled()
        } else {
            setDisabled()
        }
    }
    
    func setEnabled() {
        backgroundColor = enabledBackgroundColor
        setTitleColor(enabledTitleColor, for: .normal)
    }
    
    func setDisabled() {
        backgroundColor = disabledBackgroundColor
        setTitleColor(disabledTitleColor, for: .normal)
    }
}
