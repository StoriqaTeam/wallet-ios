//
//  QRScannerPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import AVFoundation


class QRScannerPresenter: NSObject {
    
    typealias Localization = Strings.QRScanner
    
    weak var view: QRScannerViewInput!
    weak var output: QRScannerModuleOutput?
    var interactor: QRScannerInteractorInput!
    var router: QRScannerRouterInput!
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let defaultHintMessage = Localization.defaultHintMessage
    
}


// MARK: - QRScannerViewOutput

extension QRScannerPresenter: QRScannerViewOutput {
    
    func viewIsReady() {
        view.setupInitialState(message: defaultHintMessage)
        createCaptureSession()
        configureNavigationBar()
        
        guard let captureSession = captureSession else { return }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.setPreviewLayer(previewLayer)
    }
    
    func viewWillAppear() {
        view.viewController.setWhiteNavigationBarButtons()
    }
    
}


// MARK: - QRScannerInteractorOutput

extension QRScannerPresenter: QRScannerInteractorOutput {
    
}


// MARK: - QRScannerModuleInput

extension QRScannerPresenter: QRScannerModuleInput {
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRScannerPresenter: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        view.changeAimColor(.white)
        view.changeMessage(defaultHintMessage)
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let str = metadataObject.stringValue {
            
            let result = interactor.validateAddress(str)
            
            switch result {
            case .succeed:
                captureSession!.stopRunning()
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(address: str)
            case .failed:
                view.changeAimColor(.red)
                view.changeMessage("")
            case .wrongCurrency:
                view.changeAimColor(.red)
                view.changeMessage(Localization.currenciesDoNotMatch)
            }
        }
    }
}


// MARK: - Private methods

extension QRScannerPresenter {
    
    private func configureNavigationBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setWhiteNavigationBar(title: Localization.screenTitle)
    }
    
    private func createCaptureSession() {
        //TODO: info plist camera usage description
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            failed()
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }
        
        captureSession = AVCaptureSession()
        
        if captureSession!.canAddInput(videoInput) {
            captureSession!.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession!.canAddOutput(metadataOutput) {
            captureSession!.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } else {
            failed()
            return
        }
        
        captureSession!.startRunning()
        
    }
    
    private func found(address: String) {
        log.debug("found address: " + address)
        interactor.setScannedAddress(address)
        view.dismiss()
    }
    
    private func failed() {
        captureSession = nil
        
        let alertVC = UIAlertController(title: "Scanning not supported",
                                   message: "Your device does not support scanning a code from an item.",
                                   preferredStyle: .alert)
        let action = UIAlertAction(title: Localization.okButton, style: .default) { [weak self] _ in
            self?.view.dismiss()
        }
        alertVC.addAction(action)
        alertVC.view.tintColor = Theme.Color.brightSkyBlue
        
        view.viewController.present(alertVC, animated: true)
    }
    
}
