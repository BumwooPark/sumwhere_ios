//
//  ProfileViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 9. 21..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import Moya
import SwiftyJSON
import JDStatusBarNotification


class ProfileViewModel{
  private let disposeBag = DisposeBag()
  var profile = ProfileModel()
  
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
    case tripStyle(value: [TripStyleModel.Element])
    case character(value:[CharacterModel])
    case image(value: [UIImage?])
  }
  
  let saver = PublishSubject<ProfileType>()
  let profileSubject = PublishSubject<String>()
  let profileResult: Observable<ResultModel<Bool>>
  
  init() {
    profileResult = profileSubject
      .distinctUntilChanged()
      .filter{$0.count > 2}
      .flatMapLatest{
        AuthManager.instance
          .provider
          .request(.nicknameConfirm(nickname: $0))
          .filterSuccessfulStatusCodes()
          .map(ResultModel<Bool>.self)
    }
    
    saver
      .subscribeNext(weak: self) { (weakSelf) -> (ProfileViewModel.ProfileType) -> Void in
      return {model in
        switch model {
        case .age(let value):
          weakSelf.profile.age = "\(value)"
        case .gender(let value):
          weakSelf.profile.gender = value
        case .nickname(let value):
          weakSelf.profile.nickName = value
        case .tripStyle(let values):
          weakSelf.profile.tripStyles = values
        case .character(let values):
          weakSelf.profile.character = values
        case .image(let values):
          weakSelf.profile.images = values
        }
      }
    }.disposed(by: disposeBag)
  }
  
  func putProfile(){
    
    var multiparts:[MultipartFormData] = []
    
    multiparts.append(MultipartFormData(provider: .data((profile.gender.data(using: .utf8))!), name: "gender"))
    multiparts.append(MultipartFormData(provider: .data((profile.age.data(using: .utf8))!), name: "age"))
    multiparts.append(MultipartFormData(provider: .data((profile.nickName.data(using: .utf8))!), name: "nickname"))
    
    for (idx,image) in profile.images.enumerated(){
      if image != nil {
        multiparts.append(MultipartFormData(provider: .data(UIImageJPEGRepresentation(image!, 1)!), name: "image\(idx+1)", fileName: "image\(idx+1)", mimeType: "image/jpeg"))
      }
    }
    
    do {
      let tripJSON = try JSONEncoder().encode(profile.tripStyles)
      let characterJSON = try JSONEncoder().encode(profile.character)
      multiparts.append(MultipartFormData(provider: .data(tripJSON), name: "tripStyleType", fileName: "tripStyle.json", mimeType: nil))
      multiparts.append(MultipartFormData(provider: .data(characterJSON), name: "characterType", fileName: "characterType.json"))
      
    }catch let error {
      log.error(error)
    }
    
    AuthManager.instance
      .provider.request(.createProfile(data: multiparts))
      .filterSuccessfulStatusCodes()
      .subscribe(onSuccess: { (_) in
        JDStatusBarNotification.show(withStatus: "환영 합니다", dismissAfter: 2, styleName: JDType.Success.rawValue)
        AppDelegate.instance?.proxyController.makeRootViewController()
      }) { (error) in
        guard let err = error as? MoyaError else {return}
        err.GalMalErrorHandler()
    }.disposed(by: disposeBag)
  }
}

struct ProfileModel {
  var age: String
  var nickName: String
  var gender: String
  var images: [UIImage?]
  var character: [CharacterModel]
  var tripStyles: [TripStyleModel.Element]
  
  init() {
    self.age = String()
    self.nickName = String()
    self.gender = String()
    self.images = []
    self.character = []
    self.tripStyles = []
  }
}
