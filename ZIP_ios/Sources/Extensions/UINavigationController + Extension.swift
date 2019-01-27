//
//  UINavigationController + Extension.swift
//  ZIP_ios
//
//  Created by park bumwoo on 27/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation


//네비게이션 컨트롤러 하위뷰일경우 statusbar 컬러 변경이 안되는 이슈 해결
extension UINavigationController {
  
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return topViewController?.preferredStatusBarStyle ?? .default
  }
}
