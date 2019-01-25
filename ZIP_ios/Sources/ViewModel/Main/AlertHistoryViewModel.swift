//
//  AlertHistoryViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 25/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxDataSource

struct AlertHistoryViewModel{
  var items: [AlertHistory]
}

extension AlertHistoryViewModel: SectionModelType{
  typealias Item = AlertHistory
  
  init(original: AlertHistoryViewModel, items: [AlertHistory]) {
    self = original
    self.items = items
  }
}

