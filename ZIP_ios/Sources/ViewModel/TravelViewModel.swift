//
//  TripViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 17..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct TripViewModel{
  var items: [Item]
}

extension TripViewModel: SectionModelType{
  typealias Item = TripModel
  init(original: TripViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

