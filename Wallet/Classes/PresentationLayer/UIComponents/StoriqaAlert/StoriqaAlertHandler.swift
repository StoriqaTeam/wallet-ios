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
        case success, attention
    }
    
    private let parentView: UIView
    private var blurImageView: UIImageView!
    private let alertView: AlertView
    
    init(parentView: UIView) {
        self.parentView = parentView
        self.alertView = AlertView(frame: parentView.bounds)
    }
    
    func showAlert(title: String, message: String, alertType: AlertType, duration: Double? = nil) {
        let alertImage: UIImage?
        
        switch alertType {
        case .success:
            alertImage = UIImage(named: "successIcon")
        case .attention:
            alertImage = UIImage(named: "signConfirm")
        }
        
        addBlurView()
        alertView.setTitle(title)
        alertView.setAlertImage(alertImage)
        parentView.addSubview(alertView)
        alertView.delegate = self
        
        if let duration = duration {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.dismiss()
            }
        }
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
        alertView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blurImageView.alpha = 1
            self.alertView.alpha = 1
        })
    }
}
