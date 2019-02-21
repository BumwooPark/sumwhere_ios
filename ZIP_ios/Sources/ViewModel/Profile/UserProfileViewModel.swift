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
  var profile: PublishRelay<UserProfileModel> {get}
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
  var profile: PublishRelay<UserProfileModel>
  
  init() {
    profileImageBinder = PublishRelay<[String]>()
    profile = PublishRelay<UserProfileModel>()
  }
  
  func getUserProfile(userID: Int){
    let result = AuthManager.instance.provider.request(.userWithProfile(id: "\(userID)"))
      .map(ResultModel<UserProfileModel>.self)
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
        return Observable.just([model.image1,model.image2,model.image3,model.image4].compactMap{$0})
    }.bind(to: profileImageBinder)
      .disposed(by: disposeBag)
    
    result.elements()
    
    
    
  }
}
