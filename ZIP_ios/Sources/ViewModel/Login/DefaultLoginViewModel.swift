//
//  DefaultLoginViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 9. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import Moya

class DefaultLoginViewModel{
  
  let isEnable: Observable<Bool>
  let API: Observable<Event<ResultModel<TokenModel>>>
  
  init(email:  ControlProperty<String>, password: ControlProperty<String>,tap: Observable<UITapGestureRecognizer>) {
    
    isEnable = Observable.combineLatest(email.map{$0.count > 2}, password.map{$0.count > 2}){$0 && $1}
    
    
    API = tap.withLatestFrom(Observable.combineLatest(email, password) {($0,$1)})
      .flatMapLatest({ (email: String, password: String)  in
        return AuthManager.instance
          .provider
          .request(.signIn(email: email, password: password))
          .filterSuccessfulStatusCodes()
          .map(ResultModel<TokenModel>.self)
          .asObservable()
          .materialize()
      }).share()
  }
}
