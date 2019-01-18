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
      return ["sender": sender.id,"messageId": messageId,"sentDate":sentDate.toString(),"kind":"text","isRead":isRead ? "true" : "false","contents":data]
    default:
      return [:]
    }

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
          let value = snapshot.value as! [String: [String:String]]
          Database.database().reference().child("conversations").observe(.childAdded, with: { (snap) in
            if snap.exists() {
              log.info(snapshot)
            }
          })
        }
      })
  }
  
//  class func markMessagesRead(forUserID: String)  {
//    if let currentUserID = Auth.auth().currentUser?.uid {
//      Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
//        if snapshot.exists() {
//          let data = snapshot.value as! [String: String]
//          let location = data["location"]!
//          Database.database().reference().child("conversations").child(location).observeSingleEvent(of: .value, with: { (snap) in
//            if snap.exists() {
//              for item in snap.children {
//                let receivedMessage = (item as! DataSnapshot).value as! [String: Any]
//                let fromID = receivedMessage["fromID"] as! String
//                if fromID != currentUserID {
//                  Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").setValue(true)
//                }
//              }
//            }
//          })
//        }
//      })
//    }
//  }
//
//  func downloadLastMessage(forLocation: String, completion: @escaping () -> Swift.Void) {
//    if let currentUserID = Auth.auth().currentUser?.uid {
//      Database.database().reference().child("conversations").child(forLocation).observe(.value, with: { (snapshot) in
//        if snapshot.exists() {
//          for snap in snapshot.children {
//            let receivedMessage = (snap as! DataSnapshot).value as! [String: Any]
//            self.content = receivedMessage["content"]!
//            self.timestamp = receivedMessage["timestamp"] as! Int
//            let messageType = receivedMessage["type"] as! String
//            let fromID = receivedMessage["fromID"] as! String
//            self.isRead = receivedMessage["isRead"] as! Bool
//            var type = MessageType.kind
//            switch messageType {
//            case "text":
//              type = .text
//            case "photo":
//              type = .photo
//            case "location":
//              type = .location
//            default: break
//            }
//            self.type = type
//            if currentUserID == fromID {
//              self.owner = .receiver
//            } else {
//              self.owner = .sender
//            }
//            completion()
//          }
//        }
//      })
//    }
//  }
//
//  class func send(message: ChatMessage, toID: String, completion: @escaping (Bool) -> Swift.Void)  {
//    if let currentUserID = Auth.auth().currentUser?.uid {
//      switch message.type {
//      case .location:
//        let values = ["type": "location", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
//        ChatMessage.uploadMessage(withValues: values, toID: toID, completion: { (status) in
//          completion(status)
//        })
//      case .photo:
//        let imageData = UIImageJPEGRepresentation((message.content as! UIImage), 0.5)
//        let child = UUID().uuidString
//        Storage.storage().reference().child("messagePics").child(child).putData(imageData!, metadata: nil, completion: { (metadata, error) in
//          if error == nil {
//            let path = metadata?.downloadURL()?.absoluteString
//            let values = ["type": "photo", "content": path!, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false] as [String : Any]
//            Message.uploadMessage(withValues: values, toID: toID, completion: { (status) in
//              completion(status)
//            })
//          }
//        })
//      case .text:
//        let values = ["type": "text", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
//        Message.uploadMessage(withValues: values, toID: toID, completion: { (status) in
//          completion(status)
//        })
//      }
//    }
//  }
//
//  class func uploadMessage(withValues: [String: Any], toID: String, completion: @escaping (Bool) -> Swift.Void) {
//    if let currentUserID = Auth.auth().currentUser?.uid {
//      Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
//        if snapshot.exists() {
//          let data = snapshot.value as! [String: String]
//          let location = data["location"]!
//          Database.database().reference().child("conversations").child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
//            if error == nil {
//              completion(true)
//            } else {
//              completion(false)
//            }
//          })
//        } else {
//          Database.database().reference().child("conversations").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
//            let data = ["location": reference.parent!.key]
//            Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).updateChildValues(data)
//            Database.database().reference().child("users").child(toID).child("conversations").child(currentUserID).updateChildValues(data)
//            completion(true)
//          })
//        }
//      })
//    }
//  }
  
  //MARK: Inits
  init(isRead: Bool) {
    self.sender = Sender(id: "1", displayName: "")
    self.messageId = "1"
    self.sentDate = Date()
    self.kind = .text("")
    self.isRead = isRead
  }
}
