//
//  CharactorViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 8. 6..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct InterestViewModel{
  var items: [Item]
}

extension InterestViewModel: SectionModelType{
  typealias Item = InterestModel
  init(original: InterestViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
