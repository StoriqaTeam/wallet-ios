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
    
    init(parentView: UIView) {
        self.parentView = parentView
    }
    
    
    func startLoader() {
        addDimView()
        addLoaderView()
        dimView.addSubview(loaderView)
        loaderView.showActivityIndicator()
    }
    
    func stopLoader() {
        guard let loaderView = loaderView, let dimView = dimView else {
            return
        }

        loaderView.hideActivityIndicator()
        loaderView.removeFromSuperview()
        dimView.removeFromSuperview()
        self.loaderView = nil
    }    
}


// MARK: Private methods

extension StoriqaLoader {
    private func addDimView() {
        dimView = UIView(frame: parentView.frame)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        parentView.addSubview(dimView)
    }
    
    private func addLoaderView() {
        loaderView = ActivityIndicatorView()
        loaderView.isUserInteractionEnabled = false
        loaderView.frame.size = CGSize(width: 80, height: 80)
        loaderView.center = parentView.convert(parentView.center, to: loaderView)
    }
}
