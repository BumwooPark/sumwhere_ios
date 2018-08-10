//
//  JDStatusBarManager.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 2. 4..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import JDStatusBarNotification

enum JDType: String{
  case Success = "Success"
  case Fail = "Fail"
}

func JDSetting(){
  JDStatusBarNotification.addStyleNamed(JDType.Fail.rawValue) {
    $0?.barColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    $0?.textColor = .white
    return $0
  }
  JDStatusBarNotification.addStyleNamed(JDType.Success.rawValue) {
    $0?.barColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    $0?.textColor = .white
    return $0
  }
}
