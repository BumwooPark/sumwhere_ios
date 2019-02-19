//
//  RegisterdTripViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 19/02/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import PopupDialog

internal protocol RegisterdOutputs {
  var matchList: Observable<Event<[UserTripJoinModel]>> {get}
  var deleteSuccess: PublishRelay<Void> {get}
}

internal protocol RegisterdInputs{
  func selectCard(model: UserTripJoinModel)
  func deleteTrip()
}

internal protocol RegisterdTypes{
  var inputs: RegisterdInputs {get}
  var outputs: RegisterdOutputs {get}
}

class RegisterdTripViewModel: RegisterdTypes, RegisterdOutputs, RegisterdInputs{
  var inputs: RegisterdInputs {return self}
  var outputs: RegisterdOutputs {return self}
  let disposeBag = DisposeBag()
  let model: TripModel
  let matchList: Observable<Event<[UserTripJoinModel]>>
  let deleteSuccess: PublishRelay<Void> = PublishRelay<Void>()
  
  
  init(model: TripModel) {
    self.model = model
    matchList = AuthManager
      .instance
      .provider
      .request(.GetMatchList(tripId: model.trip.id))
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[UserTripJoinModel]>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .share()
    
  }
  
  func selectCard(model: UserTripJoinModel){
    AuthManager.instance
      .provider
      .request(.PossibleMatchCount)
      .filterSuccessfulStatusCodes()
      .map(ResultModel<Int>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .subscribeNext(weak: self) { (weakSelf) -> (Int) -> Void in
        return {count in
          let popup = PopupDialog(title: "동행을 신청하시겠습니까?",
                                  message:"신청 가능횟수 \(count)",
            buttonAlignment: .horizontal,
            transitionStyle: .zoomIn,
            tapGestureDismissal: true,
            panGestureDismissal: true)
          
          popup.addButtons([Init(CancelButton(title: "취소", action: nil)){ (bt) in
            bt.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            },DefaultButton(title: "확인", action: {
              let request = MatchRequstModel(fromMatchId: model.trip.id, toMatchId: weakSelf.model.trip.id)
              AuthManager.instance.provider.request(.MatchRequest(model: request))
                .filterSuccessfulStatusCodes()
                .subscribe(onSuccess: { (response) in
                  log.info(response)
                }, onError: { (error) in
                  log.error(error)
                }).disposed(by: weakSelf.disposeBag)
            })])
          AppDelegate.instance?.window?.rootViewController?.present(popup, animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
  }
  
  func deleteTrip() {
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.titleFont = UIFont.AppleSDGothicNeoRegular(size: 16)
    dialogAppearance.titleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    dialogAppearance.messageFont = UIFont.AppleSDGothicNeoBold(size: 16)
    dialogAppearance.messageColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    let popup = PopupDialog(title: "여행을 삭제하시겠습니까?", message: "\(model.tripPlace.trip)",buttonAlignment: .horizontal,transitionStyle: .zoomIn,
                            tapGestureDismissal: true,
                            panGestureDismissal: true)
    
    
    popup.addButtons([Init(CancelButton(title: "취소", action: nil)){ (bt) in
      bt.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
      },DefaultButton(title: "확인", action: deleteAction)])
    AppDelegate.instance?.window?.rootViewController?.present(popup, animated: true, completion: nil)
  }
  
  func deleteAction(){
    AuthManager.instance.provider.request(.deleteTrip(tripId: model.trip.id))
      .filterSuccessfulStatusCodes()
      .subscribe(onSuccess: {[weak self] (response) in
        AlertType.JDStatusBar.getInstance().show(isSuccess: true, message: "삭제 되었습니다.")
        self?.deleteSuccess.accept(())
      }) { (error) in
        log.error(error)
      }.disposed(by: disposeBag)
  }
}

