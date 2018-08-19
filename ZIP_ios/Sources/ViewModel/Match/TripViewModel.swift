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
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[TripModel]>.self)
//    .catchError({ (error) -> PrimitiveSequence<SingleTrait, ResultModel<[TripModel]>> in
//      let err = error as! MoyaError
//      log.info(err)
//      return MoyaError.
//    })
//    .asObservable()

  init() {
  }
    
}
