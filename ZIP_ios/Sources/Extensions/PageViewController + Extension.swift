//
//  PageViewController + Extension.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 20..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

extension UIPageViewController {
  var isPagingEnabled: Bool {
    get {
      var isEnabled: Bool = true
      for view in view.subviews {
        if let subView = view as? UIScrollView {
          isEnabled = subView.isScrollEnabled
        }
      }
      return isEnabled
    }
    set {
      for view in view.subviews {
        if let subView = view as? UIScrollView {
          subView.isScrollEnabled = newValue
        }
      }
    }
  }
}
