//
//  QRScannerViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class QRScannerViewController: UIViewController {

    var output: QRScannerViewOutput!
    @IBOutlet private var aimView: UIView!
    @IBOutlet private var dimmingView: UIView!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var aimViewCorners: [UIView]!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        maskAimView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        output.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}


// MARK: - QRScannerViewInput

extension QRScannerViewController: QRScannerViewInput {
    
    func changeAimColor(_ color: UIColor) {
        aimView.layer.borderColor = color.cgColor
        aimViewCorners.forEach { $0.backgroundColor = color }
        messageLabel.textColor = color
    }
    
    func changeMessage(_ text: String) {
        messageLabel.text = text
    }
    
    func setPreviewLayer(_ previewLayer: CALayer) {
        previewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        
    }
    
    func setupInitialState(message: String) {
        configureAimView()
        messageLabel.text = message
    }
}


// MARK: - Private methods

extension QRScannerViewController {
    
    private func configureAimView() {
        aimView.backgroundColor = .clear
        aimView.layer.borderWidth = 1.0
        aimView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func maskAimView() {
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.31)
        
        let path = UIBezierPath(rect: aimView.frame)
        let maskLayer = CAShapeLayer()
        
        path.append(UIBezierPath(rect: dimmingView.frame))
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        maskLayer.path = path.cgPath
        
        dimmingView.layer.mask = maskLayer
    }
}
