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
    
    weak var view: QRScannerViewInput!
    weak var output: QRScannerModuleOutput?
    var interactor: QRScannerInteractorInput!
    var router: QRScannerRouterInput!
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let defaultHintMessage = "qr_code_hint".localized()
    
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
                view.changeMessage("qr_code_currency_does_not_match".localized())
            }
        }
    }
}


// MARK: - Private methods

extension QRScannerPresenter {
    
    private func configureNavigationBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setWhiteNavigationBar(title: "scan_QR".localized())
    }
    
    private func createCaptureSession() {
        //TODO: info plist camera usage description
        
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)

        switch cameraAuthorizationStatus {
        case .authorized, .notDetermined:
            break
        case .restricted:
            failed()
            return
        case .denied:
            userDeniedAccess()
            return
        }
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: cameraMediaType) else {
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
        let action = UIAlertAction(title: "ok".localized(), style: .default) { [weak self] _ in
            self?.view.dismiss()
        }
        alertVC.addAction(action)
        alertVC.view.tintColor = Theme.Color.brightSkyBlue
        
        view.viewController.present(alertVC, animated: true)
    }
    
    private func userDeniedAccess() {
        captureSession = nil
        
        let alertVC = UIAlertController(title: "No camera access",
                                        message: "Give access to camera from settings",
                                        preferredStyle: .alert)
        let showSettings = UIAlertAction(title: "Show settings", style: .default) { [weak self] _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            self?.view.dismiss()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.view.dismiss()
        }
        alertVC.addAction(cancel)
        alertVC.addAction(showSettings)
        alertVC.view.tintColor = Theme.Color.brightSkyBlue
        
        view.viewController.present(alertVC, animated: true)
    }
    
}
