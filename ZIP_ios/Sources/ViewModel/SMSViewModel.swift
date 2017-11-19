//
//  SMSViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2017. 11. 19..
//  Copyright © 2017년 park bumwoo. All rights reserved.
//

#if !RX_NO_MODULE
  import RxSwift
  import RxCocoa
#endif
import PhoneNumberKit
import PySwiftyRegex
import FirebaseAuth

struct SMSViewModel{

  let disposeBag = DisposeBag()
  
  let phoneNumberVaild: Driver<Bool>
  let authVaild: Driver<Bool>
  
  let phoneNumberKit: PhoneNumberKit = {
    let kit = PhoneNumberKit()
    kit.countryCode(for: "+82")
    return kit
  }()
  
  init(smsText: Driver<String>, authText: Driver<String>) {
    phoneNumberVaild = smsText
      .distinctUntilChanged()
      .throttle(0.3)
      .map { phoneNumber in
        return re.findall("^\\d{3}-\\d{4}-\\d{4}$", phoneNumber).isEmpty == false
    }
    
    authVaild = authText
      .distinctUntilChanged()
      .throttle(0.3)
      .map{ $0.utf8.count > 3}
  }
  
  func sendAction(email: String, phoneNumber: String){
    do{
      let numberData = try phoneNumberKit.parse(phoneNumber)
      let number = phoneNumberKit.format(numberData, toType: .e164)
      PhoneAuthProvider.provider()
        .verifyPhoneNumber(number, uiDelegate: nil) {(ID, error) in
          if error == nil{
            AuthManager.sharedManager.fireBaseId = ID
          }
      }
    }catch let error{
      log.info(error)
    }
  }
  func phoneNumberUpdate(email: String,number: String, callback: @escaping (Bool)->Void){
    return AuthManager.sharedManager.provider
      .request(.phone_update(email: email, phone_number: number))
      .asObservable()
      .jsonMap()
      .map { $0["result"]["status_code"] == 200}
      .subscribe(onNext: {
        callback($0)
      }).disposed(by: disposeBag)
  }
  
  func credentialVaild(code: String, callback: @escaping (Bool) -> Void){
    let credential = PhoneAuthProvider.provider().credential(
      withVerificationID: AuthManager.sharedManager.fireBaseId ?? "",
      verificationCode: code)
    
    Auth.auth().signIn(with: credential) { (user, error) in
      if let error = error {
        callback(false)
      }else{
        callback(true)
      }
    }
  }
}

