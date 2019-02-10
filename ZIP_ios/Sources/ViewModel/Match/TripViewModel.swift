//
//  TripViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 10..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

class TripViewModel{
  
  let planTripGetApi = AuthManager.instance
    .provider.request(.GetAllTrip)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[TripModel]>.self)
    .map{$0.result}
    .asObservable()
    .unwrap()
    .materialize()
    .share()
  
  let planTripDeleteApi = { (id: Int) in
    return AuthManager.instance
      .provider.request(.deleteTrip(tripId: id))
      .map(ResultModel<Trip>.self)
  }
  
  init() {
  }
}
