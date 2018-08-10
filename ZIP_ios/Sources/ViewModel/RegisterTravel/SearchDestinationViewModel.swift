//
//  SearchDestinationViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 29..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

class SearchDestinationViewModel{
  private let disposeBag = DisposeBag()
  
  let textObservable: Observable<String?>
  
  let datas: BehaviorRelay = BehaviorRelay<[SearchDestTVModel]>(value: [])
  
  init(text: Observable<String?>) {
    self.textObservable = text
    
    
    self.textObservable
      .filterNil()
      .debounce(0.5, scheduler: MainScheduler.instance)
      .filter({$0.count > 0})
      .bind(onNext: searchAPI)
      .disposed(by: disposeBag)
  }
  
  func searchAPI(text: String){
    AuthManager.provider.request(.searchDestination(data: text))
      .map(ResultModel<[TripType]>.self)
      .map{$0.result}
      .asObservable()
      .filterNil()
      .map{[SearchDestTVModel(items: $0)]}
      .catchErrorJustReturn([])
      .bind(to: datas)
      .disposed(by: disposeBag)
  }
  
  
}
