//
//  PlanDateViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 14/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import JTAppleCalendar

internal protocol PlanDateInputs{
  func selectDate(calendar: JTAppleCalendarView, date: Date)
  func complete()
}

internal protocol PlanDateOutputs{
  var titleBinder: Observable<String> {get}
  var selectedBinder: PublishRelay<(result: Bool, start:Date, end: Date)> { get }
  var successSubmit: PublishRelay<()> { get }
}

internal protocol PlanDateType {
  var inputs: PlanDateInputs {get}
  var outputs: PlanDateOutputs {get}
}

class PlanDateViewModel: PlanDateType, PlanDateOutputs, PlanDateInputs{
  
  var inputs: PlanDateInputs {return self}
  var outputs: PlanDateOutputs {return self}
  var titleBinder: Observable<String>
  var startDate: Date = Date()
  var endDate: Date = Date()
  var selectedCount = 0
  var selectedBinder: PublishRelay<(result: Bool, start:Date, end: Date)>
  var successSubmit: PublishRelay<()>
  
  init() {
    self.selectedBinder = PublishRelay<(result: Bool, start:Date, end: Date)>()
    self.successSubmit = PublishRelay<()>()
    let trip = tripRegisterContainer.resolve(CountryWithTrip.self)
    titleBinder = Observable.just("\(trip?.tripPlace.trip ?? String())\n언제떠날까요?")
  }
  
  func complete() {
    tripRegisterContainer.register(StartEndDate.self) { [weak self] _ in
      StartEndDate(startDate: self?.startDate ?? Date(),endDate: self?.endDate ?? Date())
    }
    successSubmit.accept(())
  }
  
  func selectDate(calendar: JTAppleCalendarView, date: Date) {
    
    let deselectAction = {(calendar: JTAppleCalendarView, date: Date) in
      calendar.deselectAllDates(triggerSelectionDelegate: false)
      calendar.selectDates([date], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
    }
    switch selectedCount{
    case 0:
      self.selectedCount += 1
      self.startDate = date
      selectedBinder.accept((false,Date(),Date()))
    case 1:
      self.selectedCount += 1
      self.endDate = date
      
      if date <= self.startDate {
        deselectAction(calendar,date)
        self.startDate = date
        self.selectedCount = 1
      }else{
        selectedBinder.accept((true,startDate,endDate))
        calendar.selectDates(from: startDate, to: self.endDate,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
      }
    case 2:
      if date > self.endDate {
        deselectAction(calendar,date)
        self.selectedCount = 1
        self.startDate = date
      }else{
        deselectAction(calendar,date)
        self.selectedCount = 1
        self.startDate = date
        self.endDate = Date()
      }
      selectedBinder.accept((false,Date(),Date()))
    default:
      selectedBinder.accept((false,Date(),Date()))
    }
  }
}
