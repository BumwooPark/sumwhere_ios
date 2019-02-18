//
//  DetailScheduleViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 12/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa
import RxKeyboard

internal protocol ScheduleInputs{
  func detailRegionTextUpdater(text: String)
  func activityTextUpdater(text: String)
}

internal protocol ScheduleOutputs{
  var imageData: Observable<String> {get}
  var iskeyBoardShow: BehaviorRelay<Bool> {get}
  var isSuccess: BehaviorRelay<Bool> {get}
  func complete()
}

internal protocol ScheduleModelType{
  var inputs: ScheduleInputs { get }
  var outputs: ScheduleOutputs { get }
}

class DetailScheduleViewModel: ScheduleModelType, ScheduleInputs, ScheduleOutputs {
  let imageData: Observable<String>
  let iskeyBoardShow: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
  let disposeBag = DisposeBag()
  let isSuccess = BehaviorRelay<Bool>(value: false)
  
  var regionText = String()
  var activityText = String()
  
  var inputs: ScheduleInputs { return self }
  var outputs: ScheduleOutputs { return self }
  
  init() {
    imageData = Observable.just("").asObservable()
    RxKeyboard.instance.visibleHeight
      .map{$0 > 0}
      .drive(iskeyBoardShow)
      .disposed(by: disposeBag)
  }
  
  func detailRegionTextUpdater(text: String) {
    regionText = text
    checkSuccess()
  }
  
  func activityTextUpdater(text: String) {
    activityText = text
    checkSuccess()
  }
  
  func checkSuccess() {
    Observable
      .just(regionText.count > 2 && activityText.count > 2)
      .bind(to: isSuccess)
      .disposed(by: disposeBag)
  }
  
  func complete() {
    var trip = tripRegisterContainer.resolve(InputTrip.self)
    trip?.concept = self.activityText
    trip?.region = self.regionText
  }
}
