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
  
  init(email: ControlProperty<String>, password: ControlProperty<String>, passwordConfirm: ControlProperty<String>) {
    self.emailValid = email
      .map {!re.findall("^[a-z0-9_+.-]+@([a-z0-9-]+\\.)+[a-z0-9]{2,4}$", $0).isEmpty}
      .skip(2)
      .share(replay: 1)
    
    self.passwordValid = password
      .map{!re.findall("^[A-Za-z0-9]{6,20}$", $0).isEmpty}
      .skip(1)
      .share(replay: 1)
    
    self.passwordConfirmValid = Observable.combineLatest(password, passwordConfirm) { $0 == $1}
  }
}
