//
//  ChatListModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation

struct ChatListModel: Codable{
  struct ChatRoom: Codable {
    let id: Int64
    let createAt: String
    let updateAt: String
  }
  
  struct ChatMember: Codable{
    let id: Int64
    let chatRoomId: Int64
    let userId: Int64
  }
  let chatRoom: ChatRoom
  let chatMember: ChatMember
}



