//
//  EmptyView.swift
//  Wallet
//
//  Created by Storiqa on 27.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class EmptyView: LoadableFromXib {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(image: UIImage, title: String? = nil) {
        configInterface()
        self.image.image = image
        
        if let title = title {
            titleLabel.text = title
        }
        
        layoutIfNeeded()
    }
}


// MARK: - Private methods

extension EmptyView {
    private func configInterface() {
        image.alpha = 0.37
        image.tintColor = Theme.Color.mainOrange
        titleLabel.textColor = Theme.Color.opaqueWhite
        titleLabel.font = Theme.Font.smallText
    }
}
