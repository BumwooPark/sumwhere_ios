//
//  JoinViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import PySwiftyRegex
import Moya

enum DataType{
  case email(String)
  case password1(String)
  case password2(String)
}

protocol JoinInput{
  func submit()
  func assign(type: DataType)
}

protocol JoinOutput {
  var isCanSubmit: BehaviorRelay<Bool>{set get}
  var submitResult: Observable<Event<TokenModel>> {get}
}

protocol JoinType{
  var input: JoinInput {get}
  var output: JoinOutput {get}
}


class JoinViewModel: JoinType,JoinOutput,JoinInput{
  var input: JoinInput{return self}
  var output: JoinOutput{return self}
  var joinModel = JoinModel()
  var isCanSubmit: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
  var submitResult: Observable<Event<TokenModel>>
  private let disposeBag = DisposeBag()
  
  init() {
    submitResult = Observable.empty()
  }
  
  func assign(type: DataType){
    switch type {
    case .email(let email):
      joinModel.email = email
    case .password1(let password):
      joinModel.password1 = password
    case .password2(let password):
      joinModel.password2 = password
    }
    isCanSubmit.accept(joinModel.validate())
  }
  
  
  func submit(){
    AuthManager.instance
      .provider
      .request(.signUp(model: joinModel))
      .filterSuccessfulStatusCodes()
      .map(TokenModel.self)
      .asObservable()
      .materialize()
      .share()
  }
}
