//
//  StoriqaLoader.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 20/10/2018.
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
        loaderView.hideActivityIndicator()
        loaderView.removeFromSuperview()
        dimView.removeFromSuperview()
        loaderView = nil
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
