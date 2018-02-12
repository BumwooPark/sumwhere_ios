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
  case profile(profileImage: Data, image1: Data)
  
}


extension ZIP: TargetType, AccessTokenAuthorizable{
  public var baseURL: URL {return URL(string: "http://192.168.0.7:8080")!}
  
  public var path: String{
    switch self {
    case .signUp:
      return "/signup"
    case .signIn:
      return "/signin"
    case .profile:
      return "/profile"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signUp:
      return .post
    case .signIn:
      return .post
    case .profile:
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
    case .signUp(let email, let password, let username):
      return .requestParameters(parameters: ["email":email,"password":password,"username":username], encoding: URLEncoding.httpBody)
    case .signIn(let email,let password):
      return .requestParameters(parameters: ["username":email,"password":password], encoding: URLEncoding.httpBody)
    case .profile(let profileImage, let image1):
      return .uploadMultipart([MultipartFormData(provider: .data(profileImage), name: "profileImage",fileName: "name",mimeType: "image/jpeg"),
                               MultipartFormData(provider: .data(image1), name: "image1"),
                               MultipartFormData(provider: .data(<#T##Data#>), name: <#T##String#>)])
    }
  }
  
  public var headers: [String : String]? {
    return [:]
  }
  
  public var authorizationType: AuthorizationType {
    switch self {
    default:
      return .none
    }
  }
}
