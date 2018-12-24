//
//  BaseFadeAnimator.swift
//  Wallet
//
//  Created by Storiqa on 24/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable multiple_closures_with_trailing_closure

import Foundation


class BaseFadeAnimator: NSObject {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
}


// MARK: - UIViewControllerAnimatedTransitioning

extension BaseFadeAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            transitionContext.containerView.addSubview(toVC.view)
            transitionContext.completeTransition(true)
            return
        }
        
        let container = transitionContext.containerView
    
        toVC.view.alpha = 0.0
        container.addSubview(toVC.view)
        UIView.animate(withDuration: duration/2) {
            fromVC.view.alpha = 0.0
        }
        
        UIView.animate(withDuration: duration/2, animations: {
            toVC.view.alpha = 1.0
        }) { (_) in
            let success = !transitionContext.transitionWasCancelled
            if !success { toVC.view.removeFromSuperview() }
            transitionContext.completeTransition(success)
        }
    }
}
