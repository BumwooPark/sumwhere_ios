//
//  UIImageView+Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 7..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView{
  func addBlurEffect()
  {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    self.addSubview(blurEffectView)
  }
}

extension Kingfisher where Base: UIImageView{
  public func setImageWithZIP(image: String){
    self.setImage(with: URL(string: AuthManager.imageURL+image))
  }
  
  
  public func setImageWithZIP(image: String, placeholder: Placeholder?, options: KingfisherOptionsInfo?, progressBlock: DownloadProgressBlock?, completionHandler: CompletionHandler?){
    self.setImage(with: URL(string: AuthManager.imageURL+image), placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
  }
}





