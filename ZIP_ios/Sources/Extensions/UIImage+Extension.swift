//
//  UIImage+Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 18..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import Accelerate

extension UIImage {
  func image(alpha: CGFloat) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    draw(at: .zero, blendMode: .normal, alpha: alpha)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}

extension UIImage{
  func resizeImageUsingVImage(size:CGSize) -> UIImage? {
    let cgImage = self.cgImage!
    var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
    var sourceBuffer = vImage_Buffer()
    defer {
      free(sourceBuffer.data)
    }
    var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
    guard error == kvImageNoError else { return nil }
    // create a destination buffer
    let scale = self.scale
    let destWidth = Int(size.width)
    let destHeight = Int(size.height)
    let bytesPerPixel = self.cgImage!.bitsPerPixel/8
    let destBytesPerRow = destWidth * bytesPerPixel
    let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
    defer {
      destData.deallocate()
    }
    var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
    // scale the image
    error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
    guard error == kvImageNoError else { return nil }
    // create a CGImage from vImage_Buffer
    var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
    guard error == kvImageNoError else { return nil }
    // create a UIImage
    let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
    destCGImage = nil
    return resizedImage
  }
}
