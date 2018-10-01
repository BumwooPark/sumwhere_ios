//
//  RelationShipViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 20..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

class RelationShipViewModel{
  
  let disposeBag = DisposeBag()
  
  init() {
  }
  
  func api(tripId: Int, startDate: String, endDate: String) -> Observable<[UserTripJoinModel]> {
    return AuthManager.instance
      .provider.request(.RelationShipMatch(tripId: tripId, startDate: startDate, endDate: endDate))
      .map(ResultModel<[UserTripJoinModel]>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
  }
  
}
