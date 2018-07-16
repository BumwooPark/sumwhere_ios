//
//  ResultModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation


// 제네릭을 쓰면 좋지 않을까 서버처럼 래퍼형식으로
struct ResultModel<T: Codable>: Codable{
  let error: ResultError?
  let result: T?
  let success: Bool
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    error = try? values.decode(ResultError.self, forKey: .result)
    success = try values.decode(Bool.self, forKey: .success)
    result = try values.decode(T.self, forKey: .result)
  }
}

struct ResultError: Codable{
  let code: Int
  let message: String
  let details: String
}

struct NicknameModel: Codable{
  let error: [String: String]
  let result: Bool
  let success: Bool
}
