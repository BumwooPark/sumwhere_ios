//
//  DetailHistoryViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 21/03/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya
import NVActivityIndicatorView

enum AcceptState: String{
  case None = "NONE"
  case Accept = "ACCEPT"
  case Refuse = "REFUSE"
}

protocol DetailHistoryOutputs {
  var acceptResult: PublishRelay<Event<Response>> {get}
}

protocol DetailHistoryInputs{
  func accept(historyID: Int)
  func refuse(historyID: Int)
}

protocol DetailHistoryTypes{
  var outputs: DetailHistoryOutputs {get}
  var inputs: DetailHistoryInputs {get}
}

class DetailHistoryViewModel: DetailHistoryTypes, DetailHistoryInputs, DetailHistoryOutputs {
  var acceptResult: PublishRelay<Event<Response>>
  
  private let disposeBag = DisposeBag()
  var outputs: DetailHistoryOutputs {return self}
  var inputs: DetailHistoryInputs {return self}
  init() {
    acceptResult = PublishRelay<Event<Response>>()
    
  }
  
  func accept(historyID: Int) {
    NVActivityIndicatorPresenter.sharedInstance.sumwhereStart()
    AuthManager.instance.provider.request(.MatchAccept(historyID: historyID))
      .filterSuccessfulStatusCodes()
      .asObservable()
      .materialize()
      .do(onNext: { (_) in
        NVActivityIndicatorPresenter.sharedInstance.sumwhereStop()
      })
      .bind(to: acceptResult)
      .disposed(by: disposeBag)
  }
  
  func refuse(historyID: Int) {
  }
}
