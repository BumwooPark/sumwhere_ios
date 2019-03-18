//
//  Alert.swift
//  ZIP_ios
//
//  Created by xiilab on 07/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation

struct PushHistory: Codable{
  let id: Int
  let typeId: Int
  let userId: Int
  let title: String
  let createdAt: String
}

struct PushType: Codable{
  let id: Int
  let name: String
  let imageURL: String
}

struct AlertHistory: Codable{
  let pushHistory: PushHistory
  let pushType: PushType
}
