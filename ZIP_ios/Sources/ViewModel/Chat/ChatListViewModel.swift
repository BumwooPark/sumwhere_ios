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
  
  let datas = BehaviorRelay<[ChatListSectionModel]>(value: [])
  lazy var API = AuthManager
    .instance
    .provider
    .request(.GetChatRoom)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[ChatListModel]>.self)
    .map{$0.result}
    .asObservable()
    .unwrap()
    .materialize()
    .share()
  
  
  init() {
    API.elements()
      .map{[ChatListSectionModel(items: $0)]}
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
}
