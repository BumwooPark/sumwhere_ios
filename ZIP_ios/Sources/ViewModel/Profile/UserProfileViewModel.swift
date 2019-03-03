//
//  ProfileViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 21/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import PopupDialog

internal protocol UserProfileOutputs{
  var profileImageBinder: PublishRelay<[String]> {get}
  var profile: PublishRelay<UserWithProfile> {get}
  var detailDatas: BehaviorRelay<[ProfileSectionModel]> {get}
  var popUp: PublishRelay<UIViewController> {get}
}

internal protocol UserProfileInputs{
  func getUserProfile(userID: Int)
  func getStatus(id: Int)
  func applyBefore()
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
  var detailDatas: BehaviorRelay<[ProfileSectionModel]>
  var profile: PublishRelay<UserWithProfile>
  var popUp = PublishRelay<UIViewController>()
  
  init() {
    profileImageBinder = PublishRelay<[String]>()
    profile = PublishRelay<UserWithProfile>()
    detailDatas = BehaviorRelay<[ProfileSectionModel]>(value: [])
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
    }.bind(to: profileImageBinder)
      .disposed(by: disposeBag)
    
    result.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          log.error(err)
        }
      }.disposed(by: disposeBag)
    
    let style = result.elements()
      .flatMapLatest {
        AuthManager.instance.provider.request(.GetTripStyles(ids: $0.profile.tripStyleType))
          .filterSuccessfulStatusCodes()
          .map(ResultModel<[TripStyle]>.self)
          .map{$0.result}
          .asObservable()
          .unwrap()
      }.flatMap { (models) -> Observable<[String : [TripStyle]]> in
        var dataDic: Dictionary<String,[TripStyle]> = [:]
        for i in models{
          if dataDic[i.type] != nil {
            dataDic[i.type]?.append(i)
          }else {
            dataDic[i.type] = [i]
          }
        }
        return Observable.just(dataDic)
      }
    
    Observable
      .combineLatest(style, result.elements()) { (style ,result) -> [ProfileSectionModel] in
        let nickname = result.user.nickname ?? String()
        return [.CharacterSection(name: nickname, items: [.CharacterSectionItem(item: result)]),
                .StyleSection(name: nickname, items: [.StyleSectionItem(item: result)]),
                .DetailStyleSection(icon: #imageLiteral(resourceName: "iconPlace.png"), title: "# 선호하는 장소", item: style["PLACE"]!.map{
                ProfileSectionItem.DetailStyleSectionItem(item: $0)
                }),
                .DetailStyleSection(icon: #imageLiteral(resourceName: "tourstyleicon.png"),title: "# 즐기는 투어스타일" ,item: style["TOUR"]!.map{
                ProfileSectionItem.DetailStyleSectionItem(item: $0)
              }),
          .DetailStyleSection(icon: #imageLiteral(resourceName: "iconActivity.png"),title: "# 좋아하는 액티비티", item: style["ACTIVITY"]!.map{
                ProfileSectionItem.DetailStyleSectionItem(item: $0)
              })
      ]
      }.bind(to: detailDatas)
    .disposed(by: disposeBag)
  }
  
  func getStatus(id: Int){
    AuthManager.instance.provider.request(.GetMatchStatus(id: "\(id)"))
      .filterSuccessfulStatusCodes()
      .map(ResultModel<MatchRequstModel>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .subscribeNext(weak: self) { (weakSelf) -> (MatchRequstModel) -> Void in
        return {model in
          log.info(model)
        }
      }.disposed(by: disposeBag)
  }
  
  func applyBefore(){
    
    AuthManager.instance
      .provider
      .request(.PossibleMatchCount)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<Int>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .flatMapLatest({(count) -> Observable<UIViewController> in
        let vc = MatchPopUpViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.item = count
        return Observable.just(vc)
      })
      .bind(to: popUp)
      .disposed(by: disposeBag)
  }
}
