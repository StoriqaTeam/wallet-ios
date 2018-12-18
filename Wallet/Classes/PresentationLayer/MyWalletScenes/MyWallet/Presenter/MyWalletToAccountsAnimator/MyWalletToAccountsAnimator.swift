//
//  MyWalletToAccountsAnimator.swift
//  Wallet
//
//  Created by Storiqa on 10/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable multiple_closures_with_trailing_closure

import UIKit

protocol MyWalletToAccountsAnimatorDelegate: class {
    func animationComplete(completion: @escaping (() -> Void))
}

class MyWalletToAccountsAnimator: NSObject {
    
    private var initialView: UIView?
    private var destinationFrame: CGRect?
    
    weak var delegate: MyWalletToAccountsAnimatorDelegate?
    
    func setInitialView(_ view: UIView) {
        self.initialView = view
    }
    
    func setDestinationFrame(_ frame: CGRect) {
        self.destinationFrame = frame
    }
}


// MARK: - UIViewControllerAnimatedTransitioning

extension MyWalletToAccountsAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let fromFrame = initialView?.frame, let toFrame = destinationFrame else { return 0.4 }
        
        let duration = log2(Double(abs(fromFrame.midY - toFrame.midY))) / 20
        return TimeInterval(duration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let toFrame = destinationFrame else { return }
        guard let snapshot = initialView else { return }
        
        let fromFrame = snapshot.frame
        let duration = transitionDuration(using: transitionContext)
        let container = transitionContext.containerView
        
        snapshot.frame = fromFrame
        snapshot.layer.cornerRadius = 10
        snapshot.layer.masksToBounds = true
        
        container.addSubview(toVC.view)
        container.addSubview(snapshot)
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            snapshot.frame = toFrame
        }) { _ in
            let success = !transitionContext.transitionWasCancelled
            self.delegate?.animationComplete(completion: {
                snapshot.removeFromSuperview()
            })
            if !success { toVC.view.removeFromSuperview() }
            transitionContext.completeTransition(success)
        }
    }
}
