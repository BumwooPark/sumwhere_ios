//
//  ChatRoomViewController2.swift
//  ZIP_ios
//
//  Created by xiilab on 11/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//


// exchange: Room ID
// Queue: {RoomID}_{UserID}

import RxSwift
import RxCocoa
import MessageKit
import RMQClient
import MessageInputBar

class ChatRoomViewController: MessagesViewController{
  
  let disposeBag = DisposeBag()
  let roomId: Int
  let userId: Int
  let conn: RMQConnection
  let channel: RMQChannel
  let exchange: RMQExchange
  let queue: RMQQueue
  let sender: Sender
  
  let messageInput = PublishRelay<RMQMessage>()
  let messagesSubject = BehaviorRelay<[MessageType]>(value: [])
  
  var messages: [MessageType] = []
  
  init(roomID: Int, userID: Int){
    self.sender = Sender(id: "\(userID)", displayName: "")
    self.roomId = roomID
    self.userId = userID
    self.conn = RMQConnection(uri: "amqp://qkrqjadn:1q2w3e4r@192.168.1.11:5672", delegate: RMQConnectionDelegateLogger())
    self.channel = conn.createChannel()
    self.exchange = channel.fanout("Room_\(roomID)", options: .durable)
    self.queue = channel.queue("Room_\(roomID)_User_\(userID)", options: .durable)
    queue.bind(exchange)
    conn.start()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    queue.subscribe({[weak self] m in
      guard let weakSelf = self else {return}
      weakSelf.messageInput.accept(m)
    })
    
    
    messageInput
      .map{ input -> MessageType in
        let result = try! JSONDecoder().decode(MessageModel.self, from: input.body)
        return result.ToMessageItem()
      }.scan(messagesSubject.value) { (values: [MessageType], value: MessageType) -> [MessageType] in
        return values + value
      }.bind(to: messagesSubject)
      .disposed(by: disposeBag)
    
    messagesSubject
      .filter({ $0.count > 0 })
      .observeOn(MainScheduler.instance)
      .subscribeNext(weak: self) { (weakSelf) -> ([MessageType]) -> Void in
        return {models in
          weakSelf.messagesCollectionView.performBatchUpdates({[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.messagesCollectionView.insertSections([weakSelf.messages.count - 1])
            if weakSelf.messages.count >= 2 {
              weakSelf.messagesCollectionView.reloadSections([weakSelf.messages.count - 2])
            }
            }, completion: { [weak self] _ in
              if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
              }
          })
        }
      }.disposed(by: disposeBag)
    
    
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messageInputBar.delegate = self
  }
  func isLastSectionVisible() -> Bool {
    guard !messages.isEmpty else { return false }
    let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
    return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
  }
  deinit {
    conn.close()
  }
}

extension ChatRoomViewController: MessagesDataSource{
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messagesSubject.value.count
  }
  
  func currentSender() -> Sender {
    return Sender(id: "any_unique_id", displayName: "Steven")
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messagesSubject.value[indexPath.section]
  }
}

extension ChatRoomViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}

extension ChatRoomViewController: MessageInputBarDelegate{
  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
    let encoder = JSONEncoder()
    do {
      let encodedData = try encoder.encode(MessageModel(id: "\(userId)", displayName: "name", messageId: "", sentDate: Date(), kind: "text", value: text.data(using: .utf8) ?? Data()))
      exchange.publish(encodedData)
    }catch let error{
      log.error(error)
    }
  }
}
