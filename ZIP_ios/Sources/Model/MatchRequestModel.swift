//
//  MatchRequestModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

struct MatchRequestModel: Codable{
  let fromMatchId: Int
  let toMatchId: Int
  let createAt: String?
}
