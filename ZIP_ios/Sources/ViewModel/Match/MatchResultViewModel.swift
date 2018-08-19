//
//  MatchResultViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 18..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct MatchResultViewModel{
  var items: [Item]
}

extension MatchResultViewModel: SectionModelType{
  typealias Item = MatchResultModel
  init(original: MatchResultViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

