//
//  TransitionAnimatorFactory.swift
//  Wallet
//
//  Created by Storiqa on 24/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransitionAnimatorFactoryProtocol: class {
    func createBaseFadeAnimator(duration: TimeInterval) -> BaseFadeAnimator
    func createWalletToAccountAnimator() -> MyWalletToAccountsAnimator
}

class TransitionAnimatorFactory: TransitionAnimatorFactoryProtocol {
    
    func createBaseFadeAnimator(duration: TimeInterval) -> BaseFadeAnimator {
        return BaseFadeAnimator(duration: duration)
    }
    
    func createWalletToAccountAnimator() -> MyWalletToAccountsAnimator {
        return MyWalletToAccountsAnimator()
    }
}
