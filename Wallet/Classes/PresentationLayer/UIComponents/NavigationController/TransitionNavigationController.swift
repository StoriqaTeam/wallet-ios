//
//  TransitionNavigationController.swift
//  Wallet
//
//  Created by Storiqa on 10/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class TransitionNavigationController: UINavigationController {
    
    private var animator: UIViewControllerAnimatedTransitioning?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func setAnimator(animator: UIViewControllerAnimatedTransitioning?) {
        self.animator = animator
    }
    
    func useDefaultTransitioningDelegate() {
        self.animator = nil
    }
}

extension TransitionNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return animator
        }
        
        return nil
        
    }
}
