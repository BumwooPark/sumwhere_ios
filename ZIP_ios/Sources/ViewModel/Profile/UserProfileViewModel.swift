//
//  ProfileViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 21/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa


internal protocol UserProfileOutputs{
  var profileImageBinder: PublishRelay<[String]> {get}
  var profile: PublishRelay<UserWithProfile> {get}
}

internal protocol UserProfileInputs{
  func getUserProfile(userID: Int)
}

internal protocol UserProfileTypes{
  var outputs: UserProfileOutputs {get}
  var inputs: UserProfileInputs {get}
}


class UserProfileViewModel: UserProfileTypes, UserProfileInputs, UserProfileOutputs{
  private let disposeBag = DisposeBag()
  var outputs: UserProfileOutputs {return self}
  var inputs: UserProfileInputs {return self}
  var profileImageBinder: PublishRelay<[String]>
  
  var profile: PublishRelay<UserWithProfile>
  
  init() {
    profileImageBinder = PublishRelay<[String]>()
    profile = PublishRelay<UserWithProfile>()
  }
  
  func getUserProfile(userID: Int){
    let result = AuthManager.instance.provider.request(.userWithProfile(id: "\(userID)"))
      .map(ResultModel<UserWithProfile>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .share()
    
    result.elements()
      .bind(to: profile)
      .disposed(by: disposeBag)
    
    
    result.elements()
      .flatMap { (model)  in
        return Observable<[String]>.just([model.profile.image1,model.profile.image2,model.profile.image3,model.profile.image4]
          .compactMap{$0}
          .filter{!$0.isEmpty})
    }.debug().bind(to: profileImageBinder)
      .disposed(by: disposeBag)
    
    
    result.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          log.error(err)
        }
      }.disposed(by: disposeBag)
    
    result.elements()
      
    
    
    
    
  }
}
