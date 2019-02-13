//
//  DetailScheduleViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 12/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//
import RxSwift
import RxCocoa

internal protocol ScheduleInputs{
  func detailRegionTextUpdater(text: String)
  func activityTextUpdater(text: String)
}

internal protocol ScheduleOutputs{
  var imageData: Observable<String> {get}
  func nextStep()
}

internal protocol ScheduleModelType{
  var inputs: ScheduleInputs { get }
  var outputs: ScheduleOutputs { get }
}

class DetailScheduleViewModel: ScheduleModelType, ScheduleInputs, ScheduleOutputs {
  let imageData: Observable<String>
  var inputs: ScheduleInputs { return self }
  var outputs: ScheduleOutputs { return self }
  
  init() {
    imageData = Observable.just("").asObservable()
  }
  
  func detailRegionTextUpdater(text: String) {
    
  }
  
  func activityTextUpdater(text: String) {
  }
  
  func nextStep() {
    
  }

}
