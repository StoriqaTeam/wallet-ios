//
//  QRScannerViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import AVFoundation


class QRScannerViewController: UIViewController {

    var output: QRScannerViewOutput!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configInterface()
        output.viewIsReady()
    }
    
    private func configInterface() {
        title = "Scan QR code"
    }
    
}

// MARK: - QRScannerViewInput

extension QRScannerViewController: QRScannerViewInput {
    
    func setPreviewLayer(_ previewLayer: CALayer) {
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
    }
    
    func presentAlertController(_ alertVC: UIAlertController) {
        present(alertVC, animated: true)
    }
    
    func setupInitialState() {

    }

}
