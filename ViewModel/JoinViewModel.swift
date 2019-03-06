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

class JoinViewModel{
  private let disposeBag = DisposeBag()
  let emailValid: Observable<Bool>
  let passwordValid: Observable<Bool>
  var passwordConfirmValid: Observable<Bool>
  
  let isButtonEnable: Observable<Bool>
  let taped: Observable<Event<ResultModel<TokenModel>>>
  
  init(email: UITextField, password: UITextField, passwordConfirm: UITextField, tap: Observable<UITapGestureRecognizer>) {
    
    self.emailValid = email.rx
      .controlEvent(.editingDidEnd)
      .withLatestFrom(email.rx.text.orEmpty)
      .map{!re.findall("^[a-z0-9_+.-]+@([a-z0-9-]+\\.)+[a-z0-9]{2,4}$", $0).isEmpty}
      .share()
    
    self.passwordValid = password.rx
      .text
      .orEmpty
      .map{!re.findall("^[A-Za-z0-9]{6,20}$", $0).isEmpty}
      .skip(2)
      .share()
    
    self.passwordConfirmValid = Observable
      .combineLatest(password.rx.text.orEmpty,
                     passwordConfirm.rx.text.orEmpty.filter{$0.count > 0}) { $0 == $1}
    self.isButtonEnable = Observable.combineLatest(emailValid, passwordConfirmValid) { $0 && $1 }
    
    let combineData = Observable
      .combineLatest(email.rx.text.orEmpty, password.rx.text.orEmpty){($0,$1)}
    
    taped = tap.withLatestFrom(combineData)
      .flatMapLatest { (data) in
        return AuthManager.instance.provider.request(.signUp(model: JoinModel(email: data.0, password: data.1)))
          .filterSuccessfulStatusCodes()
          .map(ResultModel<TokenModel>.self)
          .asObservable()
          .materialize()
    }.share()
  }
}
