//
//  QRScannerInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import AVFoundation


class QRScannerInteractor: NSObject {
    weak var output: QRScannerInteractorOutput!
    
    private var captureSession: AVCaptureSession!
    private let sendProvider: SendTransactionBuilderProtocol
    private let qrCodeResolver: QRCodeResolverProtocol
    
    init(sendProvider: SendTransactionBuilderProtocol, qrCodeResolver: QRCodeResolverProtocol) {
        self.sendProvider = sendProvider
        self.qrCodeResolver = qrCodeResolver
    }
    
}


// MARK: - QRScannerInteractorInput

extension QRScannerInteractor: QRScannerInteractorInput {
    func createPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        captureSession = AVCaptureSession()
        //TODO: info plist camera usage description
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            failed()
            return nil
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return nil
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return nil
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } else {
            failed()
            return nil
        }
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        return previewLayer
    }
}


// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRScannerInteractor: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let str = metadataObject.stringValue {
            
            if qrCodeResolver.isBTCWalletAddress(str) || qrCodeResolver.isETHWalletAddress(str) {
                captureSession.stopRunning()
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(address: str)
            }
        }
    }
    
}


// MARK: - Private methods

extension QRScannerInteractor {
    private func found(address: String) {
        log.debug("found address: " + address)
        sendProvider.setScannedAddress(address)
        
        output.codeDetected()
    }
    
    private func failed() {
        captureSession = nil
        output.failed(title: "Scanning not supported",
                      message: "Your device does not support scanning a code from an item.")
    }
}
