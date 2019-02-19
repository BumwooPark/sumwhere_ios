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
  var countryPlace: Observable<String> {get}
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
  let countryPlace: Observable<String>
  
  var regionText = String()
  var activityText = String()
  
  var inputs: ScheduleInputs { return self }
  var outputs: ScheduleOutputs { return self }
  
  init() {
    let countryModel = tripRegisterContainer.resolve(CountryTripPlace.self)
    imageData = Observable.just(countryModel?.imageURL ?? String()).asObservable()
    RxKeyboard.instance.visibleHeight
      .map{$0 > 0}
      .drive(iskeyBoardShow)
      .disposed(by: disposeBag)
    
    let trip = tripRegisterContainer.resolve(CountryWithTrip.self)
    let country = trip?.country.name ?? String()
    let place = trip?.tripPlace.trip ?? String()
    
    countryPlace = Observable<String>.just("\(country), \(place)")
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
    tripRegisterContainer.register(Concept.self) {[weak self] _ in
      Concept(region: self?.regionText ?? String() ,activity: self?.activityText ?? String())
    }
  }
}
