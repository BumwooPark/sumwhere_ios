//
//  TripStyleViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 8. 5..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct TripStyleViewModel{
  var items: [Item]
}

extension TripStyleViewModel: SectionModelType{
  typealias Item = TripStyleModel
  init(original: TripStyleViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
