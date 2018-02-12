//
//  JDStatusBarManager.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 4..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import JDStatusBarNotification

enum JDType: String{
  case LoginSuccess = "LoginSuccess"
  case LoginFail = "LoginFail"
}

func JDSetting(){
  JDStatusBarNotification.addStyleNamed(JDType.LoginFail.rawValue) {
    $0?.barColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    $0?.textColor = .white
    return $0
  }
  JDStatusBarNotification.addStyleNamed(JDType.LoginSuccess.rawValue) {
    $0?.barColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    $0?.textColor = .white
    return $0
  }
}
