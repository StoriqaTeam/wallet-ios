//
//  UIImageExtension.swift
//  Wallet
//
//  Created by Storiqa on 15/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension UIImage {
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage {
        let rectangle = CGRect(origin: CGPoint.zero, size: size)
        return getColoredRectImageWith(color: color, andRect: rectangle)
    }
    
    class func getColoredRectImageWith(color: CGColor, andRect rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = rect
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
    
    func data() -> Data? {
        if let data = self.pngData() ?? self.jpegData(compressionQuality: 1) {
            if data.count > 16 * 1024 * 1024 {
                let oldSize = self.size
                let newSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
                let newImage = self.imageWith(newSize: newSize)
                let imageData = newImage.jpegData(compressionQuality: 1)
                return imageData
            } else {
                return data
            }
        }
        return nil
    }
    
}


// MARK: Private methods

extension UIImage {
    private func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
        
        return image
    }
}
