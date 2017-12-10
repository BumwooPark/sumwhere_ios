//
//  WelcomeViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 18..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif
import SwiftyJSON
import Moya

enum AutenticationStatus{
  case error(message: JSON)
  case success(access_token: JSON, refresh_token: JSON,phone_number: JSON)
}

struct WelcomeViewModel{
  
  let credentialsValid: Driver<Bool>
  
  init(emailText: Driver<String>, passwordText: Driver<String>){
    let emailVaild = emailText
      .distinctUntilChanged()
      .throttle(0.3)
      .map { $0.utf8.count > 3 }
    
    let passwordVaild = passwordText
      .distinctUntilChanged()
      .throttle(0.3)
      .map{ $0.utf8.count > 3 }
    
    credentialsValid = Driver.combineLatest(emailVaild, passwordVaild) { $0 && $1 }
  }
  
  func login(_ email: String, _ password: String) -> PrimitiveSequence<SingleTrait, TokenModel>{
    return AuthManager.sharedManager
      .provider
      .request(.login(email: email, password: password))
      .map(TokenModel.self)
  }
}
