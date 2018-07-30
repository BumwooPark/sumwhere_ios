//
//  TravelResigerViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 29..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

enum TravelComponent{
  case startDate(date: Date)
  case endDate(date: Date)
  case destination(model: DestinationModel)
}

struct TravelInput{
  var destination: Int
  var startDate: String
  var endDate: String
  
  init() {
    destination = 0
    startDate = String()
    endDate = String()
  }
  
  func validate() -> Bool{
    guard destination != 0, startDate.length != 0, endDate.length != 0 else {return false}
    return true
  }
  
  func ToModel() -> Travel{
    return Travel(id: 0, userId: 0, destinationId: self.destination, startDate: self.startDate, endDate: self.endDate)
  }
  
}

class TravelRegisterViewModel{
  
  private let disposeBag = DisposeBag()
  let dataSubject = PublishSubject<TravelComponent>()
  let ticketView: TicketView
  var input = TravelInput()
  
  init(view: TicketView) {
    self.ticketView = view
    
    dataSubject
      .subscribe(onNext: {[weak self] (component) in
        switch component{
        case .destination(let model):
          self?.ticketView.destinationLabel.text = model.travel
          self?.ticketView.countryLabel.text = model.country
          self?.input.destination = model.id
        case .endDate(let date):
          self?.ticketView.endLabel.text = date.toFormat("yyyy-MM-dd")
          self?.input.endDate = date.toFormat("yyyy-MM-dd")
        case .startDate(let date):
          self?.ticketView.startLabel.text = date.toFormat("yyyy-MM-dd")
          self?.input.startDate = date.toFormat("yyyy-MM-dd")
        }
    }).disposed(by: disposeBag)
  }
  
  func createTravel() -> Observable<ResultModel<Travel>>{
    
    if input.validate(){
      return AuthManager.provider.request(.createTravel(model: input.ToModel()))
        .map(ResultModel<Travel>.self)
        .asObservable()
    }else{
      return Observable.error(MoyaError.requestMapping("error"))
    }
  }
}
