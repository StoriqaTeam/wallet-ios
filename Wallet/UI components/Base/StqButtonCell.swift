//
//  StqButton.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class StqButtonCell: UITableViewCell {
    @IBOutlet var button: StqButton?
    @IBOutlet var horisontalMargin: NSLayoutConstraint!
    
    var buttonTapHandlerBlock: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction private func buttonTapHandler() {
        buttonTapHandlerBlock?()
    }
}
