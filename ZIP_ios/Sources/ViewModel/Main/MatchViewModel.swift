//
//  MatchViewModel.swift
//  ZIP_ios
//
//  Created by xiilab on 2018. 7. 31..
//  Copyright © 2018년 park bumwoo. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
import RxDataSources
#endif

struct MatchViewModel{
  var items: [Item]
}

extension MatchViewModel: SectionModelType{
  typealias Item = MatchTypeModel
  init(original: MatchViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
