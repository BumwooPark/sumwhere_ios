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
import SwiftDate

internal protocol RegisterTripInputs{
  func upLoad()
}

internal protocol RegisterTripOutputs{
  var dateString: Observable<String> {get}
  var placeName: Observable<String>{get}
  var isSubmitSuccess: PublishRelay<Event<Trip>> {get}
}

internal protocol RegisterTripType{
  var inputs: RegisterTripInputs { get }
  var outputs: RegisterTripOutputs { get }
}

final class RegisterTripViewModel: RegisterTripType, RegisterTripInputs,RegisterTripOutputs{
  let disposeBag = DisposeBag()
  var dateString: Observable<String>
  var placeName: Observable<String>
  var isSubmitSuccess: PublishRelay<Event<Trip>>
  var inputs: RegisterTripInputs {return self}
  var outputs: RegisterTripOutputs {return self}
  
  init() {
    isSubmitSuccess = PublishRelay<Event<Trip>>()
    let model = tripRegisterContainer.resolve(StartEndDate.self)!
    let date = model.endDate - model.startDate
    dateString = Observable<String>.just("\(model.startDate.toFormat("MM월 dd일")) -\n \( model.endDate.toFormat("MM월 dd일")) (\(date.day ?? 0)박\((date.day ?? 0)+1)일)")
    let trip = tripRegisterContainer.resolve(CountryWithTrip.self)
    let country = trip?.country.name ?? String()
    let place = trip?.tripPlace.trip ?? String()
    placeName = Observable<String>.just("\(country), \(place)")
  }
  
  func upLoad(){
    if let matchType = tripRegisterContainer.resolve(MatchType.self),
      let concept = tripRegisterContainer.resolve(Concept.self),
      let place = tripRegisterContainer.resolve(CountryTripPlace.self),
      let date = tripRegisterContainer.resolve(StartEndDate.self){
      let model = Trip(id: 0,
           userId: 0,
           matchTypeId: matchType.id,
           activity: concept.activity,
           region: concept.region,
           tripPlaceId: place.id,
           genderType: "NONE",
           startDate: date.startDate.toFormat("yyyy-MM-dd"),
           endDate: date.endDate.toFormat("yyyy-MM-dd"),
           createdAt: String())
      AuthManager.instance.provider.request(.createTrip(model: model))
        .filterSuccessfulStatusCodes()
        .map(ResultModel<Trip>.self)
        .map{$0.result}
        .asObservable()
        .unwrap()
        .materialize()
        .bind(to: isSubmitSuccess)
        .disposed(by: disposeBag)
    }
  }
}
