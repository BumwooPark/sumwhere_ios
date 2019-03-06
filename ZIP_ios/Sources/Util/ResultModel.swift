//
//  ResultModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation
import JDStatusBarNotification
import Moya

// error와 result가 정상적으로 받아도 파싱이 안됨
struct ResultModel<T: Codable>: Codable{
  let error: ResultError?
  let result: T?
  let success: Bool
  
  func alert(success: String, complete: @escaping ()->Void ){
    if self.success{
      JDStatusBarNotification.show(withStatus: success, dismissAfter: 2, styleName: JDType.Success.rawValue)
      complete()
    }else{
      JDStatusBarNotification.show(withStatus: self.error?.details ?? "에러", dismissAfter: 2, styleName: JDType.Fail.rawValue)
    }
  }
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


struct GalMalResultModel<T: Codable>{
  let error: MoyaError?
  let result: ResultModel<T>?
}
