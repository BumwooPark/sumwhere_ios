//
//  GenericSectionModel.swift
//  ZIP_ios
//
//  Created by xiilab on 29/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxDataSources

struct GenericSectionModel<T>{
  var items: [T]
}

extension GenericSectionModel: SectionModelType{
  typealias Item = T
  
  init(original: GenericSectionModel, items: [T]) {
    self = original
    self.items = items
  }
}
