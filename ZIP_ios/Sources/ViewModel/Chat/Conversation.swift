//
//  Conversation.swift
//  ZIP_ios
//
//  Created by xiilab on 18/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import RxSwift

class Conversation {

  //MARK: Properties
  let targetUser: UserModel
  var lastMessage: ChatMessage
  
  
  //MARK: Methods
  class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
    var disposeBag = DisposeBag()
    guard let user = globalUserInfo?.user else {return}
      var conversations = [Conversation]()
      Database.database()
        .reference()
        .child("users")
        .child("\(user.id)")
        .child("conversations")
        .observe(.childAdded, with: { (snapshot) in
        if snapshot.exists() {
          let fromID = snapshot.key // 키로 타겟 유저 조회후 삽입
//          let values = snapshot.value as! [String: String]
          
          
          
          AuthManager.instance.provider.request(.anotherUser(id: fromID))
            .filterSuccessfulStatusCodes()
            .map(ResultModel<UserModel>.self)
            .map{$0.result}
            .asObservable()
            .unwrap()
            .debug()
            .subscribe({ (event) in
              switch event {
              case .next(let element):
                conversations.append(Conversation(targetUser: element, lastMessage: ChatMessage(isRead: true)))
                //            let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
                //            let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                //            conversation.lastMessage.downloadLastMessage(forLocation: location, completion: {
              //              completion(conversations)
                log.info("append")
                completion(conversations)
              case .error(let error):
                log.error(error)
              default:
                break
              }
            }).disposed(by: disposeBag)
        }
      })
    
  }
  
  //MARK: Inits
  init(targetUser: UserModel, lastMessage: ChatMessage) {
    self.targetUser = targetUser
    self.lastMessage = lastMessage
  }
}
