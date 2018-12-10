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
    func animationComplete()
}

class MyWalletToAccountsAnimator: NSObject {
    
    private var initialFrame: CGRect?
    private var destinationFrame: CGRect?
    
    weak var delegate: MyWalletToAccountsAnimatorDelegate?
    
    func setInitialFrame(_ frame: CGRect) {
        self.initialFrame = frame
    }
    
    func setDestinationFrame(_ frame: CGRect) {
        self.destinationFrame = frame
    }
}


// MARK: - UIViewControllerAnimatedTransitioning

extension MyWalletToAccountsAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let fromFrame = initialFrame else { return }
        guard let toFrame = destinationFrame else { return }
        
        guard let snapshot = fromVC.view.resizableSnapshotView(from: fromFrame,
                                                               afterScreenUpdates: true,
                                                               withCapInsets: UIEdgeInsets.zero) else { return }
        
        let duration = transitionDuration(using: transitionContext)
        let container = transitionContext.containerView
        
        snapshot.frame = fromFrame
        snapshot.layer.cornerRadius = 10
        snapshot.layer.masksToBounds = true
        snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)

        container.addSubview(toVC.view)
        container.addSubview(snapshot)
        
        toVC.view.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            toVC.view.alpha = 1.0
            snapshot.frame = toFrame
        }) { _ in
            let success = !transitionContext.transitionWasCancelled
            self.delegate?.animationComplete()
            snapshot.removeFromSuperview()
            snapshot.transform = CGAffineTransform.identity
            if !success { toVC.view.removeFromSuperview() }
            transitionContext.completeTransition(success)
        }
    }
}
