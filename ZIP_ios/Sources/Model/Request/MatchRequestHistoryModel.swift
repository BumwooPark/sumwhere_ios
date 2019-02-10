//
//  MatchReceive.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

struct MatchRequestHistoryModel: Codable{
  let fromMatchModel: Trip
  let toMatchModel: Trip
}


struct MatchRequstModel: Codable{
  let fromMatchId: Int
  let toMatchId: Int
}


