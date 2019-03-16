//
//  MainViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 19/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

internal protocol MainInputs{
}

internal protocol MainOutputs{
  var placeDatas: BehaviorRelay<[CountryWithPlace]> {get}
  var eventDatas: BehaviorRelay<[EventModel]> {get}
}

internal protocol MainTypes{
  var outputs: MainOutputs {get}
  var inputs: MainInputs {get}
}

class MainViewModel: MainTypes, MainInputs, MainOutputs {
  let disposeBag = DisposeBag()
  var outputs: MainOutputs {return self}
  var inputs: MainInputs {return self}
  var placeDatas = BehaviorRelay<[CountryWithPlace]>(value: [])
  var eventDatas: BehaviorRelay<[EventModel]> = BehaviorRelay<[EventModel]>(value: [])
  init() {
    getTripPlaceList()
    GetEvent()
  }
  
  
  func getTripPlaceList(){
    let result = AuthManager.instance.provider.request(.mainList)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[CountryWithPlace]>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .share()
    
    
    result.elements()
      .bind(to: placeDatas)
      .disposed(by: disposeBag)
    
    result.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {error in
          log.error(error)
        }
    }.disposed(by: disposeBag)
  }
  
  
  func GetEvent(){
    let result = AuthManager.instance.provider.request(.event)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[EventModel]>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .share()
    
    result.elements()
      .bind(to: eventDatas)
      .disposed(by: disposeBag)
    
    result.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          log.error(err)
        }
    }.disposed(by: disposeBag)
  }
}


