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
  let targetUser: UserWithProfile
  var lastMessage: ChatMessage
  
  //MARK: Methods
  class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
    let disposeBag = DisposeBag()
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
          let values = snapshot.value as! [String: String]
          let location = values["location"]!
          
          AuthManager.instance.provider.request(.userWithProfile(id: fromID))
            .filterSuccessfulStatusCodes()
            .map(ResultModel<UserWithProfile>.self)
            .map{$0.result}
            .asObservable()
            .unwrap()
            .subscribe({ (event) in
              switch event {
              case .next(let element):
                let emptyMessage = ChatMessage.EmptyMessage()
                let conversation = Conversation(targetUser: element, lastMessage: emptyMessage)
                conversations.append(conversation)
                conversation.lastMessage.downloadLastMessage(forLocation: location, completion: {
                  completion(conversations)
                })
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
  init(targetUser: UserWithProfile, lastMessage: ChatMessage) {
    self.targetUser = targetUser
    self.lastMessage = lastMessage
  }
}
