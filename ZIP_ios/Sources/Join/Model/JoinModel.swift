//
//  JoinModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 16..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

struct JoinModel: Codable{
  var email: String
  var password1: String
  var password2: String
  init() {
    self.email = String()
    self.password1 = String()
    self.password2 = String()
  }
  
  func validate() -> Bool{
    if self.email.count != 0 && self.password1.count != 0 && self.password2.count != 0{
      if self.password1 == self.password2 {
        return true
      }else {
        return false
      }
    }else {
      return false
    }
  }
}
