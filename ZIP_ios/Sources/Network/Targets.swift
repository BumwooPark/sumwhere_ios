//
//  Targets.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Moya

public enum ZIP{
  case signUp(model: Encodable)
  case signIn(email: String, password: String)
  case facebook(access_token: String)
  case kakao(access_token: String)
  case nicknameConfirm(nickname: String)
  case isProfile
  case country
  case travelGetAll(order: String, sortby: String, skipCount: Int)
  case createProfile(data: [MultipartFormData])
  case user
}


extension ZIP: TargetType, AccessTokenAuthorizable{
//  public var baseURL: URL {return URL(string: "http://52.197.13.138/galmal")!}
  
  public var baseURL: URL {
    #if DEBUG
    return URL(string: "http://192.168.0.3:8080/galmal")!
    #else
    return URL(string: "http://52.197.13.138/galmal")!
    #endif
  }
  public var path: String{
    switch self {
    case .signUp:
      return "/signup"
    case .signIn:
      return "/signin/email"
    case .facebook:
      return "/signin/facebook"
    case .kakao:
      return "/signin/kakao"
    case .isProfile:
      return "/restrict/existProfile"
    case .country:
      return "/country/"
    case .nicknameConfirm(let nickname):
      return "/nickname/\(nickname)"
    case .travelGetAll:
      return "/restrict/travel"
    case .createProfile:
      return "/restrict/profile"
    case .user:
      return "/restrict/user"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp,.createProfile,.kakao,.facebook:
      return .post
    default:
      return .get
    }
  }
  
  
  public var sampleData: Data {
    return Data()
  }
  
  public var task: Task {
    switch self {
    case .signUp(let json):
      return .requestJSONEncodable(json)
    case .signIn(let email,let password):
      return .requestParameters(parameters: ["email":email,"password":password], encoding: URLEncoding.queryString)
    case .facebook(let token),.kakao(let token):
      return .requestParameters(parameters: ["access_token": token], encoding: URLEncoding.httpBody)
    case let .travelGetAll(order, sortby, skipCount):
      return .requestParameters(parameters: ["order":order,"password":sortby,"skipCount": skipCount], encoding: URLEncoding.queryString)
    case .createProfile(let data):
      return .uploadMultipart(data)
    default:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
//    return ["content-type":"application/json","Accept-Language":"ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7"]
    return nil
  }
  
  public var authorizationType: AuthorizationType {
    switch self {
    case .signUp,.nicknameConfirm,.signIn:
      return .none
    default:
      return .bearer
    }
  }
}
