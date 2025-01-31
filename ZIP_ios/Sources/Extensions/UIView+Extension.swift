//
//  UIView+Extensions.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 12. 25..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import UIKit

enum GradientDirection{
  case leftToRight
  case rightToLeft
  case bottomToTop
}

extension UIView{
  func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
    let gradient = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.colors = [color1.cgColor, color2.cgColor]
    
    switch direction {
    case .leftToRight:
      gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
      gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
    case .rightToLeft:
      gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
      gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
    case .bottomToTop:
      gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
      gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
    }
    
    self.layer.insertSublayer(gradient, at: 0)
  }
  
  class func loadXib(nibName: String) -> UIView{
    return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }

}
