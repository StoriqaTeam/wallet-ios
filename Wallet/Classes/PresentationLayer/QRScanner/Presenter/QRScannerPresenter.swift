//
//  QRScannerPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import AVFoundation


class QRScannerPresenter {
    
    weak var view: QRScannerViewInput!
    weak var output: QRScannerModuleOutput?
    var interactor: QRScannerInteractorInput!
    var router: QRScannerRouterInput!
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
}


// MARK: - QRScannerViewOutput

extension QRScannerPresenter: QRScannerViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        
        guard let previewLayer = interactor.createPreviewLayer() else {
            return
        }
        
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.setPreviewLayer(previewLayer)
    }

}


// MARK: - QRScannerInteractorOutput

extension QRScannerPresenter: QRScannerInteractorOutput {
    
    func codeDetected() {
        view.dismiss()
    }
    
    func failed(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok".localized(), style: .default) { [weak self] (action) in
            self?.view.dismiss()
        }
        ac.addAction(action)
        
        view.presentAlertController(ac)
    }
    
}


// MARK: - QRScannerModuleInput

extension QRScannerPresenter: QRScannerModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
