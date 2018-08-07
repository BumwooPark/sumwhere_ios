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

enum ProfileType{
  case nickname(value: String)
  case birthDay(value: String)
  case gender(value: String)
  case tripStyle(value: [TripType])
  case interest(value:[InterestModel])
  case character(value:[CharacterModel])
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
      }
    }).disposed(by: disposeBag)
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
}
