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
  static let imageURL = "https://www.sumwhere.kr/images"
  
  static let instance = AuthManager()
  
  let prettyPrint: (Data)-> Data = {(data) in
    do {
      let dataAsJSON = try JSONSerialization.jsonObject(with: data)
      let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
      return prettyData
    } catch {
      return data // fallback to original data if it can't be serialized.
    }
  }
  
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
      let token = DefaultsKey<String>("token")
      return MoyaProvider<ZIP>(plugins: [NetworkActivityPlugin(networkActivityClosure: activityClosure),AccessTokenPlugin{Defaults[token]},NetworkLoggerPlugin(verbose: true ,responseDataFormatter: { (data: Data) -> Data in
        do {
          let dataAsJSON = try JSONSerialization.jsonObject(with: data)
          let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
          return prettyData
        } catch {
          return data // fallback to original data if it can't be serialized.
        }
      }),TokenVaildPlugin()]).rx
      #else
      return MoyaProvider<ZIP>(plugins: [AccessTokenPlugin{Defaults[.token]}]).rx
      #endif
    }else{
      return MoyaProvider<ZIP>(plugins:[NetworkLoggerPlugin(verbose: true)]).rx
    }
  }()
  
  func updateProvider() {
     let token = DefaultsKey<String>("token")

    if Defaults.hasKey(token){
      #if DEBUG
   
      self.provider = MoyaProvider<ZIP>(plugins: [AccessTokenPlugin{Defaults[token]}
        ,NetworkLoggerPlugin(verbose: true,responseDataFormatter: prettyPrint),TokenVaildPlugin()]).rx
      #else
      self.provider = MoyaProvider<ZIP>(plugins: [AccessTokenPlugin{Defaults[token]}]).rx
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
      tokenObserver.accept(String())
      AppDelegate.instance?.window?.rootViewController = WelcomeViewController()
    }
  }
}





