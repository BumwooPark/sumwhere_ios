//
//  Targets.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Moya

public enum ZIP{
  case login(email:String, kakao_id:String,password:String,nickname:String,fcm_token:String,type:String)
  case join(email:String, kakao_id:String,password:String,nickname:String,fcm_token:String,type:String)
  case phone_update(email:String, phone_number: String)
  case defaultLogin(email: String, password: String)
  case auth
}


extension ZIP: TargetType{
//  public var baseURL: URL {return URL(string: "http://172.30.1.29:8080")!}
  public var baseURL: URL {return URL(string: "http://54.92.58.119:8080")!}
  
  public var path: String{
    switch self {
    case .join:
      return "/intro/join"
    case .login:
      return "/intro/login"
    case .phone_update:
      return "/intro/phone_update"
    case .defaultLogin:
      return "/intro/login_default"
    case .auth:
      return "/auth"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .auth:
      return .get
    default:
      return .post
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
    case .join(let email,let kakao_id, let password, let nickname, let fcm_token, let type):
      return .requestParameters(parameters: ["email":email,"kakao_id":kakao_id,"password":password,"nickname":nickname,"fcmtoken":fcm_token,"type":type], encoding: URLEncoding.httpBody)
    case .login(let email,let kakao_id, let password, let nickname, let fcm_token, let type):
      return .requestParameters(parameters: ["email":email,"kakao_id":kakao_id,"password":password,"nickname":nickname,"fcmtoken":fcm_token,"type":type], encoding: URLEncoding.httpBody)
    case .phone_update(let email, let phoneNumber):
      return .requestParameters(parameters: ["phone_number": phoneNumber,"e_mail": email], encoding: URLEncoding.httpBody)
    case .defaultLogin(let email, let password):
      return .requestParameters(parameters: ["e_mail":email, "password":password], encoding: URLEncoding.httpBody)
    case .auth:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return [:]
  }
}

