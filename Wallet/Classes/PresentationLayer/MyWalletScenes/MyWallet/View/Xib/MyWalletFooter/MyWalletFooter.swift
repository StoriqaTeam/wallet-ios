//
//  MyWalletFooter.swift
//  Wallet
//
//  Created by Storiqa on 17/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class MyWalletFooter: UICollectionReusableView {
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        view.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        view.backgroundColor = .clear
    }
    
    @IBAction func buttonHandler(_ sender: Any) {
        print("----- МЕНЯ НАЖАЛИ -----")
    }
}


// MARK: - Private methods

extension MyWalletFooter {
    private func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        view.frame = bounds
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
}
