//
//  ChatMessageModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 16..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

struct MessagePayLoad: Codable{
  enum MessageType: Int, Codable{
    case string = 0
    case image
    case map
  }
  
  var id: Int64?
  let messageType: MessageType
  let data: Data
}
