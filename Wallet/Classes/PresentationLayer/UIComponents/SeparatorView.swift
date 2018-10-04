//
//  SeparatorView.swift
//  Wallet
//
//  Created by Storiqa on 20.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class SeparatorView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.lightGray
        
        let height = self.constraints.first { (constraint) -> Bool in
            return constraint.firstAttribute == NSLayoutConstraint.Attribute.height
        }
        
        height?.constant = Constants.Sizes.lineWidth
    }
}
