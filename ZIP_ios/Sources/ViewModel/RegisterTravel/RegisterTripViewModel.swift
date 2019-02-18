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

internal protocol RegisterTripInputs{
  func upLoad()
}

internal protocol RegisterTripOutputs{
  var dateString: Observable<String> {get}
}

internal protocol RegisterTripType{
  var inputs: RegisterTripInputs { get }
  var outputs: RegisterTripOutputs { get }
}


final class RegisterTripViewModel: RegisterTripType, RegisterTripInputs,RegisterTripOutputs{
  var dateString: Observable<String>
  
  var inputs: RegisterTripInputs {return self}
  var outputs: RegisterTripOutputs {return self}
  
  init() {
    dateString = Observable.empty()
    guard let model = tripRegisterContainer.resolve(InputTrip.self) else {return}
    dateString = Observable<String>.just("\(model.startDate.toFormat("MM월 dd일")) - \( model.endDate.toFormat("MM월 dd일")))")
  }
  
  func upLoad() {
    guard let model = tripRegisterContainer.resolve(InputTrip.self)?.ToModel() else {return}
    AuthManager.instance.provider.request(.createTrip(model: model))
      .filterSuccessfulStatusCodes()
      .map(ResultModel<Trip>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
  }
}
