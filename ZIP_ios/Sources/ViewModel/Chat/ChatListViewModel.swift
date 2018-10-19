//
//  ChatListModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 13..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa



class ChatListViewModel{
  private let disposeBag = DisposeBag()
  lazy var listData = AuthManager.instance.provider.request(.GetChatRoom)
    .map(ResultModel<[ChatListModel]>.self)
    .map{$0.result}
    .asObservable()
    .unwrap()
    .map{[ChatListSectionModel(items: $0)]}
    .share()
  
  init() {
  }
}
