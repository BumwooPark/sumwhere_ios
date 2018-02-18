//
//  AuthManager.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 18..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import SwiftyJSON
import SwiftyUserDefaults

class AuthManager{
  
  var fireBaseId: String?
  let provider: Reactive<MoyaProvider<ZIP>> = {
    if Defaults.hasKey("token"){
      print("토큰이 있다")
      print(Defaults[.token])
      return MoyaProvider<ZIP>(plugins: [AccessTokenPlugin(tokenClosure: Defaults[.token])]).rx
    }else{
      print("왜이게 나오지?")
      return MoyaProvider<ZIP>().rx
    }
  }()

  static var sharedManager = AuthManager()

  fileprivate init(){}
}




