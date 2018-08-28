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
  
  let getApi = AuthManager.instance
    .provider.request(.myTrip)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[TripModel]>.self)
  
  let deleteApi = { (id: Int) in
    return AuthManager.instance
      .provider.request(.deleteMyTrip(id: id))
      .map(ResultModel<Trip>.self)
  }
  
  init() {
  }
}
