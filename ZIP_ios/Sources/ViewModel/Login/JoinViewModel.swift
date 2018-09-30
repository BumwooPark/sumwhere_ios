//
//  JoinViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 2..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import Validator
import PySwiftyRegex

class JoinViewModel{

  let emailValid: Observable<Bool>
  let passwordValid: Observable<Bool>
  let passwordConfirmValid: Observable<Bool>
  
  let isButtonEnable: Observable<Bool>
  
  let taped: Observable<ResultModel<TokenModel>>
  
  init(email: ControlProperty<String>, password: ControlProperty<String>, passwordConfirm: ControlProperty<String>, tap: Observable<UITapGestureRecognizer>) {
    self.emailValid = email
      .map {!re.findall("^[a-z0-9_+.-]+@([a-z0-9-]+\\.)+[a-z0-9]{2,4}$", $0).isEmpty}
      .skip(2)
      .share(replay: 1)
    
    self.passwordValid = password
      .map{!re.findall("^[A-Za-z0-9]{6,20}$", $0).isEmpty}
      .skip(1)
      .share(replay: 1)
    
    self.passwordConfirmValid = Observable.combineLatest(password, passwordConfirm) { $0 == $1}
    self.isButtonEnable = Observable.combineLatest(emailValid, passwordConfirmValid) { $0 && $1 }
    
    taped = Observable
      .combineLatest(email, password, tap) {($0, $1, $2)}
      .flatMapLatest { (data) -> PrimitiveSequence<SingleTrait, ResultModel<TokenModel>> in
        let model = JoinModel(email: data.0, password: data.1)
        return AuthManager.instance.provider.request(.signUp(model: model))
          .filterSuccessfulStatusCodes()
          .map(ResultModel<TokenModel>.self)
    }
  }
}
