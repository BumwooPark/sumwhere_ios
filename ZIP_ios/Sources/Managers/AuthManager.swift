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
  
  
  
  static let provider: Reactive<MoyaProvider<ZIP>> = {
    if Defaults.hasKey("token"){
      #if DEBUG
      print("디버그")
        return MoyaProvider<ZIP>(plugins: [AccessTokenPlugin(tokenClosure: "1fd83e78c0cdec5d2bd9e82170208e44e6c90085"),NetworkLoggerPlugin(verbose: true)]).rx
      #else
        print("릴리즈")
        return MoyaProvider<ZIP>(plugins: [AccessTokenPlugin(tokenClosure: Defaults[.token])]).rx
      #endif
    }else{
      print("왜이게 나오지?")
      return MoyaProvider<ZIP>(plugins:[NetworkLoggerPlugin(verbose: true)]).rx
    }
  }()
  fileprivate init(){}
}




