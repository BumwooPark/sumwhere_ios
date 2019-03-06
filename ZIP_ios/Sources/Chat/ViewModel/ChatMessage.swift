//
//  Message.swift
//  ZIP_ios
//
//  Created by xiilab on 18/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import MessageKit

class ChatMessage: MessageType {
  
  //MARK: Properties
  var sender: Sender
  var messageId: String
  var sentDate: Date
  var kind: MessageKind
  var isRead: Bool
  
  func ToDictionary() -> [String: Any]{
    switch kind{
    case let .text(data):
      return ["sender": sender.id,"messageId": messageId,"sentDate":sentDate.toISO(),"kind":"text","isRead":isRead,"contents":data]
    default:
      return [:]
    }
  }
  
  class func EmptyMessage() -> ChatMessage{
    return ChatMessage(sender: Sender(id: "", displayName: ""), messageId: "", sentDate: Date(), kind: MessageKind.custom(nil), isRead: false)
  }
  
  //MARK: Methods
  class func downloadAllMessages(forUserID: String, completion: @escaping (ChatMessage) -> Swift.Void) {
    
    guard let user = globalUserInfo?.user else {return}
    
    Database
      .database()
      .reference()
      .child("users")
      .child("\(user.id)")
      .child("conversations")
      .child(forUserID)
      .observe(.value, with: { (snapshot) in
        if snapshot.exists() {
          let value = snapshot.value as! [String: String]
          let location = value["location"]!
          Database.database()
            .reference()
            .child("conversations")
            .child(location)
            .observe(.childAdded, with: { (snap) in
              if snap.exists() {
                let receivedMessage = snap.value as! [String: Any]
                guard let message = receivedMessage.ToChatMessage() else {return}
                message.messageId = snap.key
                if message.sender.id != "\(user.id)"{
                  message.sender = Sender(id: forUserID, displayName: "")
                }
                completion(message)
              }
            })
        }
      })
  }
  
  class func markMessagesRead(forUserID: String)  {
    if let currentUserID = globalUserInfo?.user.id {
      Database.database()
        .reference()
        .child("users")
        .child("\(currentUserID)")
        .child("conversations")
        .child(forUserID)
        .observeSingleEvent(of: .value, with: { (snapshot) in
          if snapshot.exists() {
            let data = snapshot.value as! [String: String]
            let location = data["location"]!
            Database.database().reference().child("conversations").child(location).observeSingleEvent(of: .value, with: { (snap) in
              if snap.exists() {
                for item in snap.children {
                  guard let receivedMessage = ((item as! DataSnapshot).value as! [String: Any]).ToChatMessage() else {return}
                  let fromID = receivedMessage.sender.id
                  if fromID != "\(currentUserID)" {
                    Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").setValue(true)
                  }
                }
              }
            })
          }
        })
    }
  }
  
  func downloadLastMessage(forLocation: String, completion: @escaping () -> Swift.Void) {
    
    Database.database().reference().child("conversations").child(forLocation).observe(.value, with: { (snapshot) in
      if snapshot.exists() {
        for snap in snapshot.children {
          
          guard let receivedMessage = ((snap as! DataSnapshot).value as! [String: Any]).ToChatMessage() else {return}
          self.isRead = receivedMessage.isRead
          self.kind = receivedMessage.kind
          self.messageId = receivedMessage.messageId
          self.sender = receivedMessage.sender
          self.sentDate = receivedMessage.sentDate
          completion()
        }
      }
    })
  }
  
  class func send(message: ChatMessage, toID: String, completion: @escaping (Bool) -> Swift.Void)  {
    ChatMessage.uploadMessage(withValues: message.ToDictionary(), toID: toID, completion: { (status) in
      completion(status)
    })
  }
  
  class func uploadMessage(withValues: [String: Any], toID: String, completion: @escaping (Bool) -> Swift.Void) {
    
    guard let user = globalUserInfo?.user else {return}
    
    
    Database.database().reference().child("users").child("\(user.id)").child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
      if snapshot.exists() {
        let data = snapshot.value as! [String: String]
        let location = data["location"]!
        Database.database()
          .reference()
          .child("conversations")
          .child(location)
          .childByAutoId()
          .setValue(withValues, withCompletionBlock: { (error, _) in
            if error == nil {
              completion(true)
            } else {
              completion(false)
            }
          })
      } else {
        Database.database().reference()
          .child("conversations")
          .childByAutoId()
          .childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
            let data = ["location": reference.parent!.key]
            Database.database().reference().child("users").child("\(user.id)").child("conversations").child(toID).updateChildValues(data)
            Database.database().reference().child("users").child(toID).child("conversations").child("\(user.id)").updateChildValues(data)
            completion(true)
          })
      }
    })
  }
  
  //MARK: Inits
  init(sender: Sender, messageId: String, sentDate: Date, kind: MessageKind, isRead: Bool) {
    self.sender = sender
    self.messageId = messageId
    self.sentDate = sentDate
    self.kind = kind
    self.isRead = isRead
  }
}
