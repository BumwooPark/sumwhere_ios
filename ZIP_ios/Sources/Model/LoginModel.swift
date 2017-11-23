//
//  LoginModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 20..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation

struct LoginModel: Codable{
  let result: Result
}

struct Result: Codable{
  var statusCode: Int
  var errorType: String?
  var message: String?
  var accessToken: String?
  var refreshToken: String?
  
  enum CodingKeys: String, CodingKey{
    case statusCode = "status_code"
    case errorType
    case message
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
  }
}
