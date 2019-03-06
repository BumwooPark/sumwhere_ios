//
//  EventInfoViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 13/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift

class EventInfoViewModel{
  
  let eventAPI = AuthManager.instance.provider.request(.event)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[EventModel]>.self)
    .map{$0.result}
    .asObservable()
    .unwrap()
    .materialize()
    .share()
  
  let InfoAPI = AuthManager.instance.provider.request(.Notice)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[NoticeModel]>.self)
    .map{$0.result}
    .asObservable()
    .unwrap()
    .materialize()
    .share()
  
  init() {
  }
}
