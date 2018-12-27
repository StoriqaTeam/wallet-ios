//
//  StoriqaAlertHandler.swift
//  Wallet
//
//  Created by Storiqa on 27/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class StoriqaAlertHandler {
    
    enum AlertType {
        case success, attension
    }
    
    private let parentView: UIView
    private var blurImageView: UIImageView!
    private let alertView: AlertView
    
    init(parentView: UIView) {
        self.parentView = parentView
        self.alertView = AlertView(frame: parentView.bounds)
    }
    
    func showAlert(title: String, message: String, alertType: AlertType) {
        let alertImage: UIImage?
        
        switch alertType {
        case .success:
            alertImage = UIImage(named: "successIcon")
        case .attension:
            alertImage = UIImage(named: "signConfirm")
        }
        
        addBlurView()
        alertView.setTitle(title)
        alertView.setAlertImage(alertImage)
        parentView.addSubview(alertView)
        alertView.delegate = self
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alertView.alpha = 0
            self.blurImageView.alpha = 0.0
        }, completion: { (_) in
            
            self.blurImageView.removeFromSuperview()
            self.alertView.removeFromSuperview()
        })
    }
}


extension StoriqaAlertHandler: AlertViewDelegate {
    func didTapOkAction() {
         self.dismiss()
    }
}

// MARK: - Private methods

extension StoriqaAlertHandler {
    
    private func addBlurView() {
        let bluredImage = captureScreen(view: parentView)
        blurImageView = UIImageView(image: bluredImage)
        self.parentView.addSubview(blurImageView)

        blurImageView.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.blurImageView.alpha = 1
        })
    }
}
