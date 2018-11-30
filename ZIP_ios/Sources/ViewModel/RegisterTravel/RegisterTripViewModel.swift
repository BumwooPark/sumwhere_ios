//
//  RegisterTripViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 09/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa

final class RegisterTripViewModel{
  enum SaveType{
    case place(model: TripType)
  }
  
  public let saver = PublishRelay<SaveType>()
  private let disposeBag = DisposeBag()
  public let dismissAction = PublishSubject<Void>()
  public let completeAction = PublishSubject<Void>()
  public let backAction = PublishSubject<Void>()
  
  public let tripPlaceBinder = PublishRelay<String>()
  public let tripPlaceMapper = PublishRelay<[TripType]>()
  
  
  init() {
    tripPlaceBinder.flatMapLatest {
      return AuthManager.instance
        .provider
        .request(.searchDestination(data: $0))
        .filterSuccessfulStatusCodes()
        .map(ResultModel<[TripType]>.self)
        .asObservable()
        .map{$0.result ?? []}
    }.bind(to: tripPlaceMapper)
      .disposed(by: disposeBag)
    
    
    saver.subscribeNext(weak: self) { (weakSelf) -> (RegisterTripViewModel.SaveType) -> Void in
      return {model in
        switch model{
        case .place(let type):
          log.info(type)
        }
      }
    }.disposed(by: disposeBag)
  }
}
