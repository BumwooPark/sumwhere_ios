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
}

struct ResultArrayModel<T: Codable>: Codable{
  let error: ResultError?
  let result: [T]?
  let success: Bool
}

struct ResultError: Codable{
  let code: Int
  let message: String
  let details: String
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    code = (try? values.decode(Int.self, forKey: .code)) ?? 0
    message = (try? values.decode(String.self, forKey: .message)) ?? String()
    details = (try? values.decode(String.self, forKey: .details)) ?? String()
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
