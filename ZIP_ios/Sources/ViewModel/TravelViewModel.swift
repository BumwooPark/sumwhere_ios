//
//  TravelViewModel.swift
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

struct TravelViewModel{
  var items: [Item]
}

extension TravelViewModel: SectionModelType{
  typealias Item = TravelModel
  init(original: TravelViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}

