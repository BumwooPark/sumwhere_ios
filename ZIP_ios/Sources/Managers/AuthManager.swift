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
        return MoyaProvider<ZIP>(plugins: [AccessTokenPlugin(tokenClosure: Defaults[.token]),NetworkLoggerPlugin(verbose: true)]).rx
      #else
        return MoyaProvider<ZIP>(plugins: [AccessTokenPlugin(tokenClosure: Defaults[.token])]).rx
      #endif
    }else{
      return MoyaProvider<ZIP>(plugins:[NetworkLoggerPlugin(verbose: true)]).rx
    }
  }()
  fileprivate init(){}
}




