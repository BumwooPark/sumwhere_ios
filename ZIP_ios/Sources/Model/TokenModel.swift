//
//  LoginModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 20..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

import Foundation

struct TokenModel: Codable{
  var token_type: String
  var expires_in: Int
  var scope: String
  var access_token: String
  var refresh_token: String
}
