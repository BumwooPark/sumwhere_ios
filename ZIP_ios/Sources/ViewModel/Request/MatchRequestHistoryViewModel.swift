//
//  MatchRequestHistoryViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 26..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct MatchRequestHistoryViewModel{
  var items: [Item]
}

extension MatchRequestHistoryViewModel: SectionModelType{
  typealias Item = MatchRequestHistoryModel
  init(original: MatchRequestHistoryViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
