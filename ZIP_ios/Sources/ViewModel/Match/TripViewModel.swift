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
  
  let api = AuthManager.provider.request(.myTrip)
    .map(ResultModel<[TripModel]>.self)
    .asObservable()

  init() {
  }
    
}
