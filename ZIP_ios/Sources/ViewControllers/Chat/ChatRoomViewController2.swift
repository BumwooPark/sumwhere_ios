//
//  ChatRoomViewController2.swift
//  ZIP_ios
//
//  Created by xiilab on 11/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import MessageKit
import RMQClient

class ChatRoomViewController2: MessagesViewController{
  
  
  let conn: RMQConnection = {
    let delegate = RMQConnectionDelegateLogger()
    return RMQConnection(uri: "amqp://qkrqjadn:1q2w3e4r@192.168.1.11:5672", delegate: delegate)
  }()
  
  lazy var queue: RMQQueue = {
    conn.start()
    let ch = conn.createChannel()
    return ch.queue("myqueue")
  }()
  
  let sender = Sender(id: "any_unique_id", displayName: "Steven")
  let messages: [MessageType] = []
  override func viewDidLoad() {
    super.viewDidLoad()
  
    queue.subscribe({ m in
      print("Received: \(String(data: m.body, encoding: String.Encoding.utf8))")
    })
    queue.publish("foo".data(using: String.Encoding.utf8))
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
  }
  
  deinit {
    conn.close()
  }
}

extension ChatRoomViewController2: MessagesDataSource{
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
  }
  
  func currentSender() -> Sender {
    return Sender(id: "any_unique_id", displayName: "Steven")
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messages[indexPath.section]
  }
}

extension ChatRoomViewController2: MessagesDisplayDelegate, MessagesLayoutDelegate {}
