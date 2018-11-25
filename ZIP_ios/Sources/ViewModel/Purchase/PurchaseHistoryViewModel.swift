//
//  PurchaseHistoryViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 23/11/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

import RxSwift
import IGListKit
import Moya

class PurchaseHistoryViewModel{
  let parentViewController: PurchaseHistoryViewController
  var haveNext = true
  private let disposeBag = DisposeBag()
  private var currentPage = 0
  
  let pageApi: (Int) -> Observable<Event<[PurchaseHistoryModel]>> = { page in
    return AuthManager.instance
      .provider
      .request(.purchaseHistory(pageNum: page))
      .filterSuccessfulStatusCodes()
      .map(ResultModel<[PurchaseHistoryModel]>.self)
      .map{$0.result}
      .asObservable()
      .unwrap()
      .materialize()
      .share()
  }
  
  init(targetViewController: PurchaseHistoryViewController) {
    self.parentViewController = targetViewController
    pageApi(0).elements()
      .map{[PurchaseSectionModel(section: 0, items: $0)]}
      .subscribeNext(weak: self) { (weakSelf) -> ([PurchaseSectionModel]) -> Void in
        return { model in
          targetViewController.item = model
          targetViewController.adapter.performUpdates(animated: true, completion: nil)
        }
    }.disposed(by: disposeBag)
    
    pageApi(0).errors()
      .subscribeNext(weak: self, { (weakSelf) -> (Error) -> Void in
        return { err in
          (err as? MoyaError)?.GalMalErrorHandler()
          weakSelf.haveNext = false
        }
      })
      .disposed(by: disposeBag)
  }
  
  func next(){
    guard self.haveNext else {return}
    self.currentPage = currentPage + 1
    let api = pageApi(currentPage)
      .do(onNext: {[weak self] (event) in
        self?.parentViewController.loading = false
      })
      
      api
      .elements()
      .map{PurchaseSectionModel(section: self.currentPage, items: $0)}
      .scan(self.parentViewController.item as? [PurchaseSectionModel] ?? []) {[unowned self] (data:[PurchaseSectionModel], models: PurchaseSectionModel) -> [PurchaseSectionModel] in
        if models.items.count == 0 {
          self.haveNext = false
          return data
        }
        return data + models
      }.subscribeNext(weak: self) { (weakSelf) -> ([PurchaseSectionModel]) -> Void in
        return {model in
          weakSelf.parentViewController.item = model
          weakSelf.parentViewController.adapter.performUpdates(animated: true, completion: nil)
        }
    }.disposed(by: disposeBag)
    
    api.errors()
      .subscribeNext(weak: self) { (weakSelf) -> (Error) -> Void in
        return {err in
          (err as? MoyaError)?.GalMalErrorHandler()
          weakSelf.haveNext = false
          weakSelf.parentViewController.adapter.performUpdates(animated: true, completion: nil)
        }
    }.disposed(by: disposeBag) 
  }
}
