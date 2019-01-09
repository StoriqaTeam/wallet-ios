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
    private var dimView: UIView!
    private var loaderView: ActivityIndicatorView!
    private var blurImageView: UIImageView!
    
    init(parentView: UIView) {
        self.parentView = parentView
    }
    
    func startLoader() {
        addBlurView()
        addLoaderView()
    }
    
    func stopLoader() {
        guard let loaderView = loaderView else {
            return
        }
        
        loaderView.hideActivityIndicator()
        loaderView.removeFromSuperview()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.blurImageView.alpha = 0.0
        }, completion: { (_) in
            self.loaderView.removeFromSuperview()
            self.blurImageView.removeFromSuperview()
            self.loaderView = nil
        })
    }
}


// MARK: Private methods

extension StoriqaLoader {
    private func addBlurView() {
        let bluredImage = captureScreen(view: parentView)
        blurImageView = UIImageView(image: bluredImage)
        self.parentView.addSubview(blurImageView)
        blurImageView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blurImageView.alpha = 1
        })
    }
    
    private func addLoaderView() {
        loaderView = ActivityIndicatorView()
        loaderView.isUserInteractionEnabled = false
        loaderView.frame.size = CGSize(width: 80, height: 80)
        loaderView.center = parentView.convert(parentView.center, to: loaderView)
        blurImageView.addSubview(loaderView)
        loaderView.showActivityIndicator()
    }
}
