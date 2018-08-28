//
//  ReceiveViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation


class ReceiveViewModel{
  
  let receiveHistoryApi = {
    return AuthManager.instance
      .provider.request(.MatchRequestReceive)
      .map(ResultModel<[MatchRequestHistoryModel]>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
  }
  
  let sendHistoryApi = {
    return AuthManager.instance
      .provider.request(.MatchRequestSend)
      .map(ResultModel<[MatchRequestHistoryModel]>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
  }
  
  
  
  init() {
  }
}
