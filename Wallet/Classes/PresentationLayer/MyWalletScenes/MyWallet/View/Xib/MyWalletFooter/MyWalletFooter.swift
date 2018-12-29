//
//  MyWalletFooter.swift
//  Wallet
//
//  Created by Storiqa on 17/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol MyWalletFooterDelegate: class {
    func buttonTapped()
}

class MyWalletFooter: UICollectionReusableView {
    
    typealias LocalizedStrings = Strings.MyWallet
    
    @IBOutlet private var addNewButton: ThinButton!
    @IBOutlet private var widthConstraint: NSLayoutConstraint!
    
    weak var delegate: MyWalletFooterDelegate?
    
    private var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        configureInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        configureInterface()
    }
    
    func setWidth(_ width: CGFloat) {
        widthConstraint.constant = width
    }
    
    @IBAction func buttonHandler(_ sender: Any) {
        delegate?.buttonTapped()
    }
}


// MARK: - Private methods

extension MyWalletFooter {
    private func configureInterface() {
        view.backgroundColor = .clear
        addNewButton.title = LocalizedStrings.addNewAccountButton
    }
    
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
