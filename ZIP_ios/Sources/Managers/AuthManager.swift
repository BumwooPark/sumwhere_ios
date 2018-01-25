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


class AuthManager{

  var fireBaseId: String?
  let provider: Reactive<MoyaProvider<ZIP>> = {
    if let token = UserDefaults.standard.string(forKey: "access_token") {
      log.info(token)
      return MoyaProvider<ZIP>(plugins: [AccessTokenPlugin(tokenClosure: token)]).rx
    }else{
      log.error("왜이게 나오지?")
      return MoyaProvider<ZIP>().rx
    }
  }()

  static var sharedManager = AuthManager()

  fileprivate init(){}
}




