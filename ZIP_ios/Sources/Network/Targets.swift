//
//  Targets.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Moya

public enum ZIP{
  case login(email: String, password: String)
  case join(email: String, kakao_id: String, password: String, nickname: String, fcmToken: String)
  case main
}


extension ZIP: TargetType, AccessTokenAuthorizable{
  public var baseURL: URL {return URL(string: "http://54.92.58.119:8080")!}
  
  public var path: String{
    switch self {
    case .join:
      return "/intro/join"
    case .login:
      return "/intro/login"
    case .main:
      return "/api/main"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .join:
      return .post
    case .login:
      return .post
    case .main:
      return .get
    }
  }
  
  
  public var sampleData: Data {
    //    switch self {
    //    case .zen:
    //      return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
    //    case .userProfile(let name):
    //      return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
    //    case .userRepositories(let name):
    //      return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
    //    case .branches:
    //      return "[{\"name\": \"master\"}]".data(using: String.Encoding.utf8)!
    //    }
    return Data()
  }
  
  public var task: Task {
    switch self {
    case .join(let email,let kakao_id, let password, let nickname, let fcmToken):
      return .requestParameters(parameters: ["email":email,"kakao_id":kakao_id,"password":password,"nickname":nickname, "fcm_Token":fcmToken], encoding: URLEncoding.httpBody)
    case .login(let email,let password):
      return .requestParameters(parameters: ["email":email,"password":password], encoding: URLEncoding.httpBody)
    case .main:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return [:]
  }
  
  public var authorizationType: AuthorizationType {
    switch self {
    case .main:
      return .bearer
    default:
      return .none
    }
  }
}
