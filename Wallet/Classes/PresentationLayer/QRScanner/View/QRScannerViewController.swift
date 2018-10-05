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
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
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
    }
    
    func setPreviewLayer(_ previewLayer: CALayer) {
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        view.bringSubviewToFront(aimView)
        
    }
    
    func setupInitialState() {
        configInterface()
        configureAimView()
    }
}


// MARK: - Private methods

extension QRScannerViewController {
    private func configInterface() {
        title = "Scan QR code"
    }
    
    private func configureAimView() {
        aimView.backgroundColor = .clear
        aimView.roundCorners(radius: 5)
        aimView.layer.borderWidth = 2.0
        aimView.layer.borderColor = UIColor.white.cgColor
    }
}
