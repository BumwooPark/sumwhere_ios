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
}


extension ZIP: TargetType, AccessTokenAuthorizable{
  public var baseURL: URL {return URL(string: "http://52.197.13.138/galmal")!}
  
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
      return "/profile"
    case .country:
      return "/country/"
    case .nicknameConfirm(let nickname):
      return "/nickname/\(nickname)"
    case .travelGetAll:
      return "/restrict/travel"
//    case .profile:
//      return "/profile"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp:
      return .post
    case .signIn:
      return .get
    case .facebook:
      return .post
    case .kakao:
      return .post
    case .nicknameConfirm:
      return .get
    default:
      return .get
//    case .profile:
//      return .post
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
    case .signUp(let json):
      return .requestJSONEncodable(json)
    case .signIn(let email,let password):
      return .requestParameters(parameters: ["email":email,"password":password], encoding: URLEncoding.queryString)
    case .facebook(let token):
      return .requestParameters(parameters: ["access_token": token], encoding: URLEncoding.httpBody)
    case .kakao(let token):
      return .requestParameters(parameters: ["access_token": token], encoding: URLEncoding.httpBody)
    case .nicknameConfirm:
      return .requestPlain
    case let .travelGetAll(order, sortby, skipCount):
      return .requestParameters(parameters: ["order":order,"password":sortby,"skipCount": skipCount], encoding: URLEncoding.queryString)
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
