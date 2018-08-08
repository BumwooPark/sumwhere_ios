//
//  ProfileViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 7..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import PopupDialog
import Moya
import Validator

enum ProfileType{
  case nickname(value: String)
  case birthDay(value: String)
  case gender(value: String)
  case tripStyle(value: [TripStyleModel])
  case interest(value:[InterestModel])
  case character(value:[CharacterModel])
  case introText(value: String)
}

enum ValidateError: String, Error{
  case empty = "비어있습니다."
  case length = "길이가 일치하지 않습니다."
}

class ProfileViewModel{
  var item: UserModel?
  private let disposeBag = DisposeBag()
  
  let viewController: SetProfileViewController
  let modelSaver = PublishSubject<ProfileType>()
  
  let profileAPI = AuthManager.provider.request(.user)
    .map(ResultModel<UserModel>.self)
    .retry(3)
    .asObservable()
    .share()
  
  lazy var getProfile = profileAPI
    .map{$0.result}
    .filterNil()
    .do(onNext: {(model) in
      self.item = model
    }).share()
  
  lazy var getTripType = profileAPI
    .map{$0.result?.profile?.tripType}
    .filterNil()
    .share()
  
  lazy var getInterestType = profileAPI
    .map{$0.result?.profile?.interestType}
    .filterNil()
    .share()
  
  lazy var getCharacterType = profileAPI
    .map{$0.result?.profile?.characterType}
    .filterNil()
    .share()
  
  
  init(viewController: SetProfileViewController) {
    self.viewController = viewController
    
    modelSaver.subscribe(onNext: { (type) in
      switch type{
      case .birthDay(let value):
        self.item?.profile?.birthday = value
      case .character(let value):
        self.item?.profile?.characterType = value
      case .gender(let value):
        self.item?.profile?.gender = value
      case .interest(let value):
        self.item?.profile?.interestType = value
      case .nickname(let value):
        self.item?.nickname = value
      case .tripStyle(let value):
        self.item?.profile?.tripType = value
      case .introText(let value):
        self.item?.profile?.introText = value
        }
    }).disposed(by: disposeBag)
  }
  
  func valid() -> Bool{
    var nicknameRule = ValidationRuleSet<String>()
    nicknameRule.add(rule: ValidationRuleRequired(error: ValidateError.empty))
    nicknameRule.add(rule: ValidationRuleLength(min:2, max:10, error: ValidateError.length))
    
    guard let result = item?.nickname?.validate(rules: nicknameRule) else {return false}
    let genderRule = ValidationRuleRequired<String>(error: ValidateError.empty)
    guard let gender = item?.profile?.gender else {return false}
    let genderResult = gender.validate(rule: genderRule)
    
    switch result.merge(with: genderResult){
    case .valid:
      return true
    case .invalid(let error):
      return false
    }
    
    guard let tripType = item?.profile?.tripType,
      let characterType = item?.profile?.characterType,
      let interestType = item?.profile?.interestType else {return false}
    
    if tripType.count > 0 && characterType.count > 0 && interestType.count > 0 {
      return true
    }else {
      return false
    }
  }
  
  func commit(){
    if valid(){
      putProfile()
    }
  }
  
  
  func nickname(textField: UITextField){
    profileAPI
      .map{$0.result?.nickname}
      .filterNil()
      .subscribe(onNext: { (text) in
        textField.text = text
      }).disposed(by: disposeBag)
  }
  
  func overlapAPI(nickname: String){
    AuthManager.provider.request(.nicknameConfirm(nickname: nickname))
      .map(ResultModel<Bool>.self)
      .map{$0.result}
      .asObservable()
      .catchErrorJustReturn(false)
      .filterNil()
      .bind(onNext: profileAlertView)
      .disposed(by: disposeBag)
  }
  
  private func profileAlertView(result: Bool){
    var popup: PopupDialog!
    if result{
      popup = PopupDialog(title: "닉네임", message: "사용 가능합니다.")
    }else{
      popup = PopupDialog(title: "닉네임", message: "사용 불가합니다.")
    }
    let backButton = DefaultButton(title: "확인", height: 60, dismissOnTap: true, action: nil)
      popup.addButtons([backButton])
      viewController.present(popup, animated: true, completion: nil)
    }
  
  private func putProfile(){
    
    var multiparts:[MultipartFormData] = []
    multiparts.append(MultipartFormData(provider: .data((item?.profile?.gender.data(using: .utf8))!), name: "gender"))
    multiparts.append(MultipartFormData(provider: .data((item?.profile?.birthday.data(using: .utf8))!), name: "birthday"))
    multiparts.append(MultipartFormData(provider: .data((item?.nickname?.data(using: .utf8))!), name: "nickname"))
  
    
//    for (idx,image) in images.enumerated(){
//      if image != nil {
//        multiparts.append(MultipartFormData(provider: .data(UIImageJPEGRepresentation(image!, 1)!), name: "image\(idx+1)", fileName: "image\(idx+1)", mimeType: "image/jpeg"))
//      }
//    }
    
//    AuthManager.provider.request(.createProfile(data: multiparts))
//      .map(ResultModel<UserModel>.self)
//      .subscribe(onSuccess: { (model) in
//        model.alert(success: "환영합니다"){[weak self] in
//          if self?.navigationController == nil {
//            self?.dismiss(animated: true, completion: nil)
//          }else{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//              AppDelegate.instance?.proxyController.makeRootViewController()
//            })
//            self?.navigationController?.popViewController(animated: true)
//          }
//        }
//      }) { (error) in
//        log.error(error)
//      }.disposed(by: disposeBag)
  }
}
