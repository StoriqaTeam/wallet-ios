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
    
//    private func startScanning() {
//        output.startScanning()
//
//        captureSession = AVCaptureSession()
//
//        //TODO: info plist camera usage description
//
//        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
//        let videoInput: AVCaptureDeviceInput
//
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)
//        } catch {
//            return
//        }
//
//        if (captureSession.canAddInput(videoInput)) {
//            captureSession.addInput(videoInput)
//        } else {
//            failed();
//            return;
//        }
//
//        let metadataOutput = AVCaptureMetadataOutput()
//
//        if (captureSession.canAddOutput(metadataOutput)) {
//            captureSession.addOutput(metadataOutput)
//
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//        } else {
//            failed()
//            return
//        }
//
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
//        previewLayer.frame = view.layer.bounds;
//        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
//        view.layer.addSublayer(previewLayer);
//
//        captureSession.startRunning();
//    }
//
//    func failed() {
//        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//        captureSession = nil
//    }
}

//extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        captureSession.stopRunning()
//        
//        if let metadataObject = metadataObjects.first {
//            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
//            
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            found(code: readableObject.stringValue!);
//        }
//        
//        dismiss(animated: true)
//    }
//    
//    func found(code: String) {
//        print(code)
//    }
//}

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
