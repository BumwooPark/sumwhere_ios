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
import Result

class AuthManager{
  
  var fireBaseId: String?
  static let imageURL = "http://192.168.1.7:8080/images"
  
  static let instance = AuthManager()
  
  let activityClosure: NetworkActivityPlugin.NetworkActivityClosure = { activityType, targetType in
    switch activityType {
    case .began:
      log.info("began")
    case .ended:
      log.info("ended")
    }
  }
  
  lazy var provider: Reactive<MoyaProvider<ZIP>> = {
    if Defaults.hasKey("token"){
      #if DEBUG
      return MoyaProvider<ZIP>(plugins: [NetworkActivityPlugin(networkActivityClosure: activityClosure),AccessTokenPlugin(tokenClosure: Defaults[.token]),NetworkLoggerPlugin(verbose: true),TokenVaildPlugin()]).rx
      #else
        return MoyaProvider<ZIP>(plugins: [AccessTokenPlugin(tokenClosure: Defaults[.token])]).rx
      #endif
    }else{
      return MoyaProvider<ZIP>(plugins:[NetworkLoggerPlugin(verbose: true)]).rx
    }
  }()
  
  func updateProvider() {
    if Defaults.hasKey("token"){
      #if DEBUG
      self.provider = MoyaProvider<ZIP>(plugins: [NetworkActivityPlugin(networkActivityClosure: activityClosure),AccessTokenPlugin(tokenClosure: Defaults[.token]),NetworkLoggerPlugin(verbose: true),TokenVaildPlugin()]).rx
      #else
      self.provider = MoyaProvider<ZIP>(plugins: [AccessTokenPlugin(tokenClosure: Defaults[.token])]).rx
      #endif
    }else{
      self.provider = MoyaProvider<ZIP>(plugins:[NetworkLoggerPlugin(verbose: true)]).rx
    }
  }
  
  fileprivate init(){}
}

final class TokenVaildPlugin: PluginType{
  func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
    guard case Result.failure(_) = result else {return}
    if result.value?.statusCode == 401 {
      AppDelegate.instance?.window?.rootViewController = WelcomeViewController()
    }
  }
}





