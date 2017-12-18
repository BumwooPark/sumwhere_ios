//
//  UIImage+Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 18..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation

extension UIImage {
  func image(alpha: CGFloat) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    draw(at: .zero, blendMode: .normal, alpha: alpha)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}
