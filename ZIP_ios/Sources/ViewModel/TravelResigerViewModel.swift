////
////  TripResigerViewModel.swift
////  ZIP_ios
////
////  Created by park bumwoo on 2018. 7. 29..
////  Copyright © 2018년 park bumwoo. All rights reserved.
////
//
//import RxSwift
//import RxCocoa
//import Moya
//import SwiftDate
//
//enum TripComponent{
//  case startDate(date: Date)
//  case endDate(date: Date)
//  case destination(model: TripType)
//}
//
//struct TripInput{
//  
//  enum TripInputError: Error{
//    case destination(message: String)
//    case date(message: String)
//  }
//  
//  var destination: Int
//  var startDate: String
//  var endDate: String
//  
//  init() {
//    destination = 0
//    startDate = String()
//    endDate = String()
//  }
//  
//  func validate() -> TripInputError?{
//
//    let dateRule = ValidationRuleLength(min: 4, error: TripInputError.date(message: "날짜를 선택해 주세요."))
//    
//    let destinationResult = destination.validate(rule: ValidationRuleCondition<Int>(error: TripInputError.destination(message: "목적지를 입력해 주세요.")) { (result) -> Bool in
//      return (result ?? 0) > 0
//    })
//    
//    let dateTodayRule = ValidationRuleCondition<String>(error: TripInputError.date(message: "날짜를 선택해 주세요.")) { (result) -> Bool in
//      guard let dateResult = result?.toDate() else {return false}
//      return !dateResult.isToday
//    }
//    
//    let startDateResult = startDate.validate(rule: dateRule)
//    let endDateRusult = endDate.validate(rule: dateRule)
//    let startDateTodayResult = startDate.validate(rule: dateTodayRule)
//    let endDateTodayResult = startDate.validate(rule: dateTodayRule)
//    
//    switch ValidationResult.merge(results: [destinationResult,startDateResult,endDateRusult,startDateTodayResult,endDateTodayResult]){
//    case .valid:
//      return nil
//    case .invalid(let errors):
//      for err in errors{
//        return err as? TripInputError
//      }
//      return nil
//    }
//  }
//  
//  func ToModel() -> Trip{
//    return Trip(id: 0, userId: 0, tripTypeId: self.destination, startDate: self.startDate, endDate: self.endDate)
//  }
//}
//
//class TripRegisterViewModel{
//  
//  private let disposeBag = DisposeBag()
//  let dataSubject = PublishSubject<TripComponent>()
//  let ticketView: TicketView
//  private var input = TripInput()
//  
//  init(view: TicketView) {
//    self.ticketView = view
//    
//    dataSubject
//      .subscribe(onNext: {[weak self] (component) in
//        switch component{
//        case .destination(let model):
//          self?.ticketView.destinationLabel.text = model.trip
//          self?.ticketView.countryLabel.text = model.country
//          self?.input.destination = model.id
//        case .endDate(let date):
//          self?.ticketView.endLabel.text = date.toFormat("yyyy-MM-dd")
//          self?.input.endDate = date.toFormat("yyyy-MM-dd")
//        case .startDate(let date):
//          self?.ticketView.startLabel.text = date.toFormat("yyyy-MM-dd")
//          self?.input.startDate = date.toFormat("yyyy-MM-dd")
//        }
//    }).disposed(by: disposeBag)
//  }
//  
//  func validate() -> TripInput.TripInputError?{
//    return input.validate()
//  }
//  
//  
//  func serverTripValidate(model: TripType) -> Observable<TripType> {
//    return AuthManager.instance
//      .provider.request(.TripDestinationValidate(id: model.id))
//      .map(ResultModel<Int>.self)
//      .asObservable()
//      .flatMap { (resultModel) -> Observable<TripType> in
//        if resultModel.result == 0{
//          return Observable.just(model)
//        }else{
//          return Observable<TripType>.error(MoyaError.requestMapping("이미 등록하신 여행지 입니다."))
//        }
//    }
//  }
//  
//  func serverDateValidate(start: Date, end: Date) -> Observable<Bool>{
//    
//    let startDate = start.toFormat("yyyy-MM-dd")
//    let endDate = end.toFormat("yyyy-MM-dd")
//    
//    return AuthManager.instance
//      .provider
//      .request(.TripDateValidate(start: startDate, end: endDate))
//      .map(ResultModel<Int>.self)
//      .asObservable()
//      .flatMap { (resultModel) -> Observable<Bool> in
//        if resultModel.result == 0{
//          return Observable.just(true)
//        }else{
//          return Observable<Bool>.error(MoyaError.requestMapping("해당 날짜의 여행이 존재합니다."))
//        }
//    }
//  }
//  
//  func createTrip() -> PrimitiveSequence<SingleTrait, ResultModel<Trip>>{
//    return AuthManager.instance
//      .provider.request(.createTrip(model: input.ToModel()))
//      .map(ResultModel<Trip>.self)
//  }
//}
