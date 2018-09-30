//
//  ProfileViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift

class ProfileViewModel{
  private let disposeBag = DisposeBag()
  
  let getCharacters = AuthManager.instance.provider.request(.GetAllCharacter)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[CharacterModel]>.self)
    .map{$0.result}
    .asObservable()
    .share()
  
  
  let tripStyleAPI =  AuthManager.instance.provider
    .request(.GetAllTripStyle)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[TripStyleModel]>.self)
    .map{$0.result}
    .asObservable()
    .filterNil()
    .share()
 
  
  enum ProfileType{
    case nickname(value: String)
    case age(value: Int)
    case gender(value: String)
    case tripStyle(value: [TripStyleModel])
    case interest(value:[InterestModel])
    case character(value:[CharacterModel])
    case introText(value: String)
    case image(value: [UIImage?])
    case overLapCheck(value: Bool)
  }
  
  let saver = PublishSubject<ProfileType>()
  let profileSubject = PublishSubject<String>()
  let profileResult: Observable<ResultModel<Bool>>
  
  init() {
    profileResult = profileSubject
      .debug("profileSubject", trimOutput: true)
      .distinctUntilChanged()
      .filter{$0.count > 2}
      .flatMapLatest{
        AuthManager.instance
          .provider
          .request(.nicknameConfirm(nickname: $0))
          .filterSuccessfulStatusCodes()
          .map(ResultModel<Bool>.self)
      }
    
    saver.subscribe(onNext: { (model) in
      log.info(model)
    }).disposed(by: disposeBag)
  }
}
