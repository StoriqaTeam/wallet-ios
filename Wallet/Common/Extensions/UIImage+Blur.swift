//
//  UIImage+Blur.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 23/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import UIKit
import Accelerate

extension UIImage {
    
    func applyStoriqaBlur(radius: CGFloat,
                          tintColor: UIColor,
                          saturationFactor: CGFloat) -> UIImage? {
        
        if self.size.height < 1 || self.size.width < 1 { return nil }
        
        let floatEpsilon: CGFloat = 1.19209290e-7
        let hasBlur = radius > floatEpsilon
        let hasSaturationChange = abs(saturationFactor - 1) > floatEpsilon
        
        let imageRect = CGRect(origin: .zero, size: self.size)
        let renderer = UIGraphicsImageRenderer(size: self.size)
        return renderer.image { imageContext in
            
            let context = imageContext.cgContext
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -self.size.height)
            
            if hasBlur || hasSaturationChange {
                var effectInBuffer: vImage_Buffer = vImage_Buffer(), scratchBuffer1: vImage_Buffer = vImage_Buffer()
                var inputBuffer: vImage_Buffer, outputBuffer: vImage_Buffer
                
                var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                                  bitsPerPixel: 32,
                                                  colorSpace: nil,
                                                  bitmapInfo: [.byteOrder32Little,
                                                               CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)],
                                                  version: 0,
                                                  decode: nil,
                                                  renderingIntent: .defaultIntent)
                
                _ = vImageBuffer_InitWithCGImage(&effectInBuffer, &format, nil, self.cgImage!, vImage_Flags(kvImagePrintDiagnosticsToConsole))
                
                vImageBuffer_Init(&scratchBuffer1, effectInBuffer.height, effectInBuffer.width, format.bitsPerPixel, vImage_Flags(kvImageNoFlags))
                inputBuffer = effectInBuffer
                outputBuffer = scratchBuffer1
                
                if hasBlur {
                    let inputRadius = (radius * self.scale) - 2 < floatEpsilon ? 2 : (radius * self.scale)
                    let floatRadius: CGFloat = floor((inputRadius * 3 * sqrt(CGFloat.pi*2) / 4 + 0.5) / 2)
                    var radius = UInt32(floatRadius)
                    radius |= 1
                    
                    let tempBufferSize = vImageBoxConvolve_ARGB8888(&inputBuffer,
                                                                    &outputBuffer,
                                                                    nil,
                                                                    0,
                                                                    0,
                                                                    radius,
                                                                    radius,
                                                                    nil,
                                                                    vImage_Flags(kvImageEdgeExtend) | vImage_Flags(kvImageGetTempBufferSize))
                    let tempBuffer = malloc(tempBufferSize)
                    vImageBoxConvolve_ARGB8888(&inputBuffer,
                                               &outputBuffer,
                                               tempBuffer,
                                               0,
                                               0,
                                               radius,
                                               radius,
                                               nil,
                                               vImage_Flags(kvImageEdgeExtend))
                    
                    vImageBoxConvolve_ARGB8888(&outputBuffer,
                                               &inputBuffer,
                                               tempBuffer,
                                               0,
                                               0,
                                               radius,
                                               radius,
                                               nil,
                                               vImage_Flags(kvImageEdgeExtend))
                    
                    vImageBoxConvolve_ARGB8888(&inputBuffer,
                                               &outputBuffer,
                                               tempBuffer,
                                               0,
                                               0,
                                               radius,
                                               radius,
                                               nil,
                                               vImage_Flags(kvImageEdgeExtend))
                    
                    swap(&inputBuffer, &outputBuffer)
                }
                
                if hasSaturationChange {
                    let sf = saturationFactor
                    let floatingPointSaturationMatrix: [CGFloat] = [
                        0.0722 + 0.9278 * sf,  0.0722 - 0.0722 * sf,  0.0722 - 0.0722 * sf,  0,
                        0.7152 - 0.7152 * sf,  0.7152 + 0.2848 * sf,  0.7152 - 0.7152 * sf,  0,
                        0.2126 - 0.2126 * sf,  0.2126 - 0.2126 * sf,  0.2126 + 0.7873 * sf,  0,
                        0,                    0,                    0,                    1
                    ]
                    
                    let divisor: Int32 = 256
                    let saturationMatrix = floatingPointSaturationMatrix.map { Int16(roundf(Float($0)*Float(divisor))) }
                    vImageMatrixMultiply_ARGB8888(&inputBuffer,
                                                  &outputBuffer,
                                                  saturationMatrix,
                                                  divisor,
                                                  nil,
                                                  nil,
                                                  vImage_Flags(kvImageNoFlags))
                }
                
                var effectCGImage = vImageCreateCGImageFromBuffer(&inputBuffer,
                                                                  &format,
                                                                  { $1?.deallocate() },
                                                                  nil,
                                                                  vImage_Flags(kvImageNoAllocate),
                                                                  nil)
                
                if effectCGImage == nil {
                    effectCGImage = vImageCreateCGImageFromBuffer(&inputBuffer,
                                                                  &format,
                                                                  nil,
                                                                  nil,
                                                                  vImage_Flags(kvImageNoFlags),
                                                                  nil)
                    free(&inputBuffer)
                }
                
                
                context.saveGState()
                context.draw(effectCGImage!.takeUnretainedValue(), in: imageRect)
                context.restoreGState()
            } else {
                context.draw(self.cgImage!, in: imageRect)
            }
            
            context.saveGState()
            context.setFillColor(tintColor.cgColor)
            context.fill(imageRect)
            context.restoreGState()
        }
    }
}


func captureScreen(view: UIView) -> UIImage {
    let image = view.makeSnapshot()
    guard let snapImage = image else { fatalError("Fail to snap image") }
    let tintColor = UIColor.black.withAlphaComponent(0)
    let bluredImage = snapImage.applyStoriqaBlur(radius: 20,
                                                 tintColor: tintColor,
                                                 saturationFactor: 1)
    guard let bluredImg = bluredImage else { fatalError("Fail to blur image") }
    return bluredImg
}
