//
//  MainViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 19/10/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif


class MainViewModel {
  
  let userAPI = AuthManager.instance.provider.request(.user)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<UserModel>.self)
    .retry(3)
    .asObservable()
    .materialize()
    .share()
  
  init() {
    
  }
}


