//
//  BaseButton.swift
//  Wallet
//
//  Created by Storiqa on 22.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class BaseButton: UIButton {
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitleColor(UIColor.mainBlue, for: .normal)
    }
}
