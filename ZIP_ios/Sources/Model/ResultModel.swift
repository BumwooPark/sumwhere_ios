//
//  ResultModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation


// error와 result가 정상적으로 받아도 파싱이 안됨
struct ResultModel<T: Codable>: Codable{
  let error: ResultError?
  let result: T?
  let success: Bool
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    error = try values.decode(ResultError.self, forKey: .error)
    success = try values.decode(Bool.self, forKey: .success)
    result = try? values.decode(T.self, forKey: .result)
  }
}

struct ResultError: Codable{
  let code: Int
  let message: String
  let details: String
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    code = try values.decode(Int.self, forKey: .code)
    message = try values.decode(String.self, forKey: .message)
    details = try values.decode(String.self, forKey: .details)
  }
}

struct TokenModel: Codable{
  let token: String
}

struct NicknameModel: Codable{
  let error: [String: String]
  let result: Bool
  let success: Bool
}
