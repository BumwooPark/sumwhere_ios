//
//  AlertFactory.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 22..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import JDStatusBarNotification

protocol AlertAction {
  func show(isSuccess: Bool, message: String)
  func close()
}

enum AlertType{
  case JDStatusBar
  func getInstance() -> AlertAction {
    switch self {
    case .JDStatusBar:
      return StatusBarJD()
    }
  }
}

struct StatusBarJD: AlertAction{
  func show(isSuccess: Bool, message: String) {
    if isSuccess{
      JDStatusBarNotification.show(withStatus: message, dismissAfter: 2, styleName: JDType.Success.rawValue)
    }else{
      JDStatusBarNotification.show(withStatus: message, dismissAfter: 2, styleName: JDType.Fail.rawValue)
    }
  }
  
  func close() {
  }
}


