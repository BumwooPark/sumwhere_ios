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

struct AuthPlugin: PluginType {
  let token: String
  
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    request.addValue("jwt " + token, forHTTPHeaderField: "Authorization")
    return request
  }
}

class AuthManager{
  
  var fireBaseId: String?
  let provider = MoyaProvider<ZIP>().rx
  let authProvider: MoyaProvider<ZIP> = {
    if let token = UserDefaults.standard.string(forKey: "access_token") {
      return MoyaProvider<ZIP>(plugins: [AuthPlugin(token: token)])
    }else{
      return MoyaProvider<ZIP>()
    }
  }()
  
  static var sharedManager = AuthManager()
  
  fileprivate init(){}
  
  func login(_ email: String, _ password: String) -> Observable<JSON>{
    
    return provider.request(.defaultLogin(email: email, password: password))
      .asObservable()
      .jsonMap()
  }
}

