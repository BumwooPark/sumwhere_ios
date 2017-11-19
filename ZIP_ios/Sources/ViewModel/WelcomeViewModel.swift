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
  
  func login(email: String, password: String) -> Observable<AutenticationStatus>{
    return AuthManager.sharedManager.login(email, password)
      .map({ json in
      if json["result"]["status_code"] == 200{
        return AutenticationStatus.success(access_token: json["result"]["access_token"], refresh_token: json["result"]["refresh_token"], phone_number: json["result"]["phone_number"])
      }else{
        return AutenticationStatus.error(message: json["result"]["message"])
      }
    })
  }
}
