//
//  SearchViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 08/05/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxCocoa
import RxSwift

protocol SearchInput{
  func searchTag(tag: String)
}

protocol SearchOutput{
//  var searchResult: BehaviorRelay<>
}

protocol SearchTypes {
  var input: SearchInput {get}
  var output: SearchOutput {get}
}

class SearchViewModel:SearchTypes, SearchInput, SearchOutput{
  let disposeBag = DisposeBag()
  var input: SearchInput {return self}
  var output: SearchOutput {return self}
  
  init() {
  }
  
  func searchTag(tag: String) {
    AuthManager.instance.provider.request(.placeSearch(tag: tag))
      .subscribe(onSuccess: { (response) in
        log.info(response)
      }) { (error) in
        log.error(error)
    }.disposed(by: disposeBag)
    
  }
}
