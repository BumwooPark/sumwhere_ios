//
//  PurchaseHistoryViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import Moya

class PurchaseHistoryViewModel{
  private let disposeBag = DisposeBag()
  private let api = AuthManager.instance.provider.request(.purchaseHistory)
    .filterSuccessfulStatusCodes()
    .map(ResultModel<[PurchaseHistoryModel]>.self)
    .map{$0.result}
    .asObservable()
    .unwrap()
    .materialize()
    .share()
  
  init(targetViewController: PurchaseHistoryViewController) {
    api.elements()
      .map{[PurchaseSectionModel(section: 0, items: $0)]}
      .subscribeNext(weak: self) { (weakSelf) -> ([PurchaseSectionModel]) -> Void in
        return { model in
          targetViewController.item = model
          targetViewController.adapter.performUpdates(animated: true, completion: nil)
        }
    }.disposed(by: disposeBag)
    
    api.errors()
      .subscribe(onNext: { (err) in
        (err as? MoyaError)?.GalMalErrorHandler()
      }).disposed(by: disposeBag)
  }
}
