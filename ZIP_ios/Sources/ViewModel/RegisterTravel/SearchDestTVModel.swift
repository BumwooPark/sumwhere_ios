//
//  SearchDestTVModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 2018. 7. 29..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct SearchDestTVModel{
  var items: [Item]
}

extension SearchDestTVModel: SectionModelType{
  typealias Item = TripType
  init(original: SearchDestTVModel, items: [Item]) {
    self = original
    self.items = items
  }
}
