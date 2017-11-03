//
//  Targets.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 4..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Moya

public enum ZIP{
  case login(parameter:[String: String])
  case join
}


extension ZIP: TargetType{
  public var baseURL: URL {return URL(string: "http://172.30.1.11:5000")!}
  
  public var path: String{
    switch self {
    case .join:
      return "/join"
    case .login:
      return "/login"
    }
  }
  
  public var method: Moya.Method {
    return .post
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
    case .join:
      return .requestParameters(parameters: [:], encoding: URLEncoding.default)
    case .login(let parameter):
      return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
    }
  }
  
  public var headers: [String : String]? {
    //    return ["Content-Type": "application/json"]
    return [:]
  }
}

