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
    func viewDidBecomeVisible()
    func animationComplete(completion: @escaping (() -> Void))
}

class MyWalletToAccountsAnimator: NSObject {
    
    private var selectedIndex: Int?
    private var selectedView: UIView?
    private var visibleViews: [UIView]?
    private var destinationFrame: CGRect?
    
    weak var delegate: MyWalletToAccountsAnimatorDelegate?
    
    func setDestinationFrame(_ frame: CGRect) {
        self.destinationFrame = frame
    }
    
    func setVisibleViews(_ views: [UIView], selectedIndex: Int) {
        self.visibleViews = views
        self.selectedIndex = selectedIndex
        
        if selectedIndex < views.count {
            self.selectedView = views[selectedIndex]
        }
    }
}


// MARK: - UIViewControllerAnimatedTransitioning

extension MyWalletToAccountsAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let toVC = transitionContext?.viewController(forKey: .to) else { return 0.67 }
        let duration = TimeInterval(toVC.view.frame.height / 1200)
        return TimeInterval(duration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let toFrame = destinationFrame,
            let selectedIndex = selectedIndex,
            let selectedView = selectedView,
            var visibleViews = visibleViews else {
                self.delegate?.animationComplete(completion: {})
                transitionContext.containerView.addSubview(toVC.view)
                transitionContext.completeTransition(true)
                return
        }
        
        let moveSelectedDuration = log2(Double(abs(selectedView.frame.midY - toFrame.midY))) / 18
        let container = transitionContext.containerView
        let hideViewsDuration = transitionDuration(using: transitionContext)
        
        visibleViews.forEach { container.addSubview($0) }
        visibleViews.remove(at: selectedIndex)
        
        toVC.view.alpha = 0
        container.insertSubview(toVC.view, belowSubview: selectedView)
        
        UIView.animate(withDuration: moveSelectedDuration, delay: 0, options: [.curveEaseOut], animations: {
            selectedView.frame = toFrame
        })
        
        UIView.animate(withDuration: hideViewsDuration/4, delay: hideViewsDuration/4*3, animations: {
            toVC.view.alpha = 1
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hideViewsDuration/2) { [weak self] in
            self?.delegate?.viewDidBecomeVisible()
        }
        
        UIView.animate(withDuration: hideViewsDuration, animations: {
            visibleViews.forEach { $0.frame.origin.y += toVC.view.frame.height }
        }) { _ in
            self.delegate?.animationComplete(completion: {
                selectedView.removeFromSuperview()
                visibleViews.forEach { $0.removeFromSuperview() }
            })
            
            let success = !transitionContext.transitionWasCancelled
            if !success { toVC.view.removeFromSuperview() }
            transitionContext.completeTransition(success)
        }
    }
}
