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
    private var blurEffectView: UIVisualEffectView?
    var blurBackImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verticalCenterConstraint.constant = Constants.Sizes.screenHeight/2
        containerView.roundCorners(radius: 7)
        addBlurBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateBlur()
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
        
        dissmissBlur(completion: completion)
    }
}


// MARK: - Private methods

extension BasePopUpViewController {
    private func addBlurBackground() {
        
        if let storiqaBlur = blurBackImageView {
            storiqaBlur.alpha = 0
            view.backgroundColor = .clear
            view.insertSubview(storiqaBlur, at: 0)
            return
        }
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.frame
        
        guard let blur = blurEffectView else { return }
        view.insertSubview(blur, at: 0)
        blurEffectView?.alpha = 0
        view.backgroundColor = .clear
    }
    
    private func animateBlur() {
        if let storiqaBlur = blurBackImageView {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                self.view.backgroundColor = .clear
                storiqaBlur.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
                guard let blur = self.blurEffectView else { return }
                blur.alpha = 0.9
            }, completion: nil)
        }
    }
    
    private func dissmissBlur(completion:  @escaping () -> Void) {
        if let storiqaBlur = blurBackImageView {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                storiqaBlur.alpha = 0.0
            }, completion: { _ in
                self.dismiss(animated: false, completion: completion)
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                guard let blur = self.blurEffectView else { return }
                blur.alpha = 0.0
            }, completion: { _ in
                self.dismiss(animated: false, completion: completion)
            })
        }
    }
}
