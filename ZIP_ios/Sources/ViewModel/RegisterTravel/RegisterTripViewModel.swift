//
//  RegisterTripViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 09/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

final class RegisterTripViewModel{
  enum SaveType{
    case place(model: TripType)
    case date(start: Date, end: Date)
  }
  
  public let saver = PublishRelay<SaveType>()
  private let disposeBag = DisposeBag()
  public let dismissAction = PublishSubject<Void>()
  public let completeAction = PublishSubject<Void>()
  public let submitAction = PublishSubject<Void>()
  public let backAction = PublishSubject<Void>()
  public let scrollToFirst = PublishRelay<Void>()
  public let tripPlaceBinder = PublishRelay<String>()
  public let tripPlaceMapper = PublishRelay<[TripType]>()
  private var inputModel = InputTrip()
  
  
  lazy var submitResult = submitAction
    .map{[unowned self] _ in return self.inputModel.ToModel()}
    .flatMapLatest { (model) in
      AuthManager.instance.provider.request(.createTrip(model: model))
        .filterSuccessfulStatusCodes()
        .map(ResultModel<Trip>.self)
        .map{$0.result}
        .asObservable()
        .unwrap()
        .materialize()
    }.share()
  
  init() {
    let binder = tripPlaceBinder.flatMapLatest {
      return AuthManager.instance
        .provider
        .request(.searchDestination(data: $0))
        .filterSuccessfulStatusCodes()
        .map(ResultModel<[TripType]>.self)
        .map{$0.result}
        .asObservable()
        .unwrap()
    }.materialize()
      .share()
    
    binder.elements()
      .bind(to: tripPlaceMapper)
      .disposed(by: disposeBag)
    binder.errors()
    .subscribe(onNext: { (err) in
        (err as? MoyaError)?.GalMalErrorHandler()
      }).disposed(by: disposeBag)
  
    saver
      .subscribeNext(weak: self) { (weakSelf) -> (RegisterTripViewModel.SaveType) -> Void in
      return {model in
        switch model{
        case .place(let type):
          self.inputModel.tripTypeId = type.id
        case .date(let start, let end):
          self.inputModel.startDate = start.toFormat("yyyy-MM-dd")
          self.inputModel.endDate = end.toFormat("yyyy-MM-dd")
        }
      }
    }.disposed(by: disposeBag)
  }
}
