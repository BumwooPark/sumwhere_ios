//
//  FirebaseChatController.swift
//  ZIP_ios
//
//  Created by xiilab on 18/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Firebase
import FirebaseDatabase

class FirebaseChatController: NSObject{
  let database = Database.database().reference()
  override init() {
    super.init()
    
//    database.child("users/8/conversations/7").childByAutoId().setValue(ChatMessage(isRead: true).ToDictionary()) { (error, database) in
//      if error != nil {
//          log.error(error)
//      }
//
//    }
  }
}
