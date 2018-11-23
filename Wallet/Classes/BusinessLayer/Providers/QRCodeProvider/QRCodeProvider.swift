//
//  QRCodeProvider.swift
//  Wallet
//
//  Created by Storiqa on 01.10.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol QRCodeProviderProtocol {
    func createQRFromString(_ str: String, size: CGSize) -> UIImage?
}

class QRCodeProvider: QRCodeProviderProtocol {
    func createQRFromString(_ str: String, size: CGSize) -> UIImage? {
        let data = str.data(using: String.Encoding.utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            
            guard let qrCodeImage = filter.outputImage else {
                return nil
            }
            
            let scaleX = size.width / qrCodeImage.extent.size.width
            let scaleY = size.height / qrCodeImage.extent.size.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            let transformed = qrCodeImage.transformed(by: transform)
            let context = CIContext(options: nil)
            
            guard let cgImage = context.createCGImage(transformed, from: transformed.extent) else {
                return nil
            }
            
            let image = UIImage(cgImage: cgImage)
            return image
        }
        return nil
    }
}
