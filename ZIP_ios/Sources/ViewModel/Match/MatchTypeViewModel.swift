//
//  MatchTypeViewModel.swift
//  ZIP_ios
//
//  Created by park bumwoo on 27/01/2019.
//  Copyright © 2019 park bumwoo. All rights reserved.
//

import RxDataSources


struct MatchTypeViewModel{
  var items: [MatchType]
}

extension MatchTypeViewModel: SectionModelType{
  typealias Item = MatchType
  
  init(original: MatchTypeViewModel, items: [MatchType]) {
    self = original
    self.items = items
  }
}
