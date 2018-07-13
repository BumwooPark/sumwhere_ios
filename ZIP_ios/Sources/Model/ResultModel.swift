//
//  ResultModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

struct ResultModel: Codable{
  let error: [String: String]
  let result: [String: String]
  let success: Bool
}
