//
//  Targets.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Moya

public enum ZIP{
  case signUp(email: String, password: String, username: String)
  case signIn(email: String, password: String)
  case facebook(access_token: String)
  case kakao(access_token: String)
  case isProfile
//  case profile(profileImage: Data, image1: Data)
}


extension ZIP: TargetType, AccessTokenAuthorizable{
  public var baseURL: URL {return URL(string: "http://210.100.238.118:8080")!}
  
  public var path: String{
    switch self {
    case .signUp:
      return "/signup"
    case .signIn:
      return "/signin"
    case .facebook:
      return "/facebook"
    case .kakao:
      return "/kakao"
    case .isProfile:
      return "/profile"
//    case .profile:
//      return "/profile"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp:
      return .post
    case .signIn:
      return .post
    case .facebook:
      return .post
    case .kakao:
      return .post
    case .isProfile:
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
    case .signUp(let email, let password, let username):
      return .requestParameters(parameters: ["email":email,"password":password,"username":username], encoding: URLEncoding.httpBody)
    case .signIn(let email,let password):
      return .requestParameters(parameters: ["username":email,"password":password], encoding: URLEncoding.httpBody)
    case .facebook(let token):
      return .requestParameters(parameters: ["access_token": token], encoding: URLEncoding.httpBody)
    case .kakao(let token):
      return .requestParameters(parameters: ["access_token": token], encoding: URLEncoding.httpBody)
    case .isProfile:
      return .requestPlain
//    case .profile(let profileImage, let image1):
//      return .uploadMultipart([MultipartFormData(provider: .data(profileImage), name: "profileImage",fileName: "name",mimeType: "image/jpeg"),
//                               MultipartFormData(provider: .data(image1), name: "image1"),
//                               MultipartFormData(provider: .data(<#T##Data#>), name: <#T##String#>)])
    }
  }
  
  public var headers: [String : String]? {
    return [:]
  }
  
  public var authorizationType: AuthorizationType {
    switch self {
    default:
      return .bearer
    }
  }
}
