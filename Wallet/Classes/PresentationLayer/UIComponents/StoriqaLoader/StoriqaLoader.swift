//
//  StoriqaLoader.swift
//  Wallet
//
//  Created by Storiqa on 20/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class StoriqaLoader {
    
    private let parentView: UIView
    private var loaderView: ActivityIndicatorView!
    private var blurEffectView: UIVisualEffectView!
    
    init(parentView: UIView) {
        self.parentView = parentView
    }
    
    func startLoader() {
        addBlurView()
        addLoaderView()
        blurEffectView.contentView.addSubview(loaderView)
        loaderView.showActivityIndicator()
    }
    
    func stopLoader() {
        guard let loaderView = loaderView else {
            return
        }
        
        loaderView.hideActivityIndicator()
        loaderView.removeFromSuperview()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blurEffectView.alpha = 0.0
        }, completion: { _ in
            loaderView.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
            self.loaderView = nil
        })
    }
}


// MARK: Private methods

extension StoriqaLoader {
    private func addBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = parentView.frame
        parentView.addSubview(blurEffectView)
        blurEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.alpha = 0.9
        }
    }
    
    private func addLoaderView() {
        loaderView = ActivityIndicatorView()
        loaderView.isUserInteractionEnabled = false
        loaderView.frame.size = CGSize(width: 80, height: 80)
        loaderView.center = parentView.convert(parentView.center, to: loaderView)
    }
}
