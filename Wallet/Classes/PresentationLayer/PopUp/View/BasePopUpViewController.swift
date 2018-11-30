//
//  BasePopUpViewController.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class BasePopUpViewController: UIViewController {
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var verticalCenterConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verticalCenterConstraint.constant = Constants.Sizes.screenHeight/2
        containerView.roundCorners(radius: 7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        verticalCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.65,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseIn],
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateDismiss(completion: @escaping () -> Void) {
        verticalCenterConstraint.constant = -Constants.Sizes.screenHeight/17
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.verticalCenterConstraint.constant = Constants.Sizes.screenHeight
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.backgroundColor = .clear
        }, completion: { _ in
            self.dismiss(animated: false, completion: completion)
        })
    }
    
    
}
